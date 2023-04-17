/*
	This file is part of solidity.

	solidity is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	solidity is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with solidity.  If not, see <http://www.gnu.org/licenses/>.
*/

#include <libyul/optimiser/ReasoningBasedSimplifier.h>
#include <libyul/optimiser/SMTSolver.h>

#include <libyul/optimiser/SSAValueTracker.h>
#include <libyul/optimiser/Semantics.h>
#include <libyul/AST.h>
#include <libyul/Dialect.h>

#include <libsmtutil/SMTPortfolio.h>
#include <libsmtutil/Helpers.h>

#include <libsolutil/CommonData.h>

#include <libsolutil/BooleanLP.h>

#include <utility>
#include <memory>

using namespace std;
using namespace solidity;
using namespace solidity::util;
using namespace solidity::yul;
using namespace solidity::smtutil;

void ReasoningBasedSimplifier::run(OptimiserStepContext& _context, Block& _ast)
{
	set<YulString> ssaVars = SSAValueTracker::ssaVariables(_ast);
	ReasoningBasedSimplifier simpl{_context.dialect, ssaVars};
	// Hack to inject the boolean lp solver.
	simpl.m_solver = make_unique<BooleanLPSolver>();
	simpl(_ast);
}

std::optional<string> ReasoningBasedSimplifier::invalidInCurrentEnvironment()
{
	return nullopt;
}

void ReasoningBasedSimplifier::operator()(VariableDeclaration& _varDecl)
{
	SMTSolver::encodeVariableDeclaration(_varDecl);
}

void ReasoningBasedSimplifier::operator()(If& _if)
{
	if (!SideEffectsCollector{m_dialect, *_if.condition}.movable())
		return;

	cout << "Checking if condition  can be false" << endl;
	smtutil::Expression condition = encodeExpression(*_if.condition);
	m_solver->push();
	m_solver->addAssertion(condition == constantValue(0));
	cout << "  running check" << endl;
	CheckResult result = m_solver->check({}).first;
	m_solver->pop();
	if (result == CheckResult::UNSATISFIABLE)
	{
		cout << " unsat => cannot be false!" << endl;
		Literal trueCondition = m_dialect.trueLiteral();
		trueCondition.debugData = debugDataOf(*_if.condition);
		_if.condition = make_unique<yul::Expression>(move(trueCondition));
	}
	else
	{
		cout << "Checking if condition  can be true" << endl;
		m_solver->push();
		// TODO change this to >= 1 for simplicity?
		m_solver->addAssertion(condition >= 1);
		cout << "  running check" << endl;
		CheckResult result2 = m_solver->check({}).first;
		m_solver->pop();
		if (result2 == CheckResult::UNSATISFIABLE)
		{
			cout << " unsat => cannot be true!" << endl;
			Literal falseCondition = m_dialect.zeroLiteralForType(m_dialect.boolType);
			falseCondition.debugData = debugDataOf(*_if.condition);
			_if.condition = make_unique<yul::Expression>(move(falseCondition));
			_if.body = yul::Block{};
			// Nothing left to be done.
			return;
		}
		cout << " unknown :(" << endl;
	}

	m_solver->push();
	cout << "Setting condition true inside body" << endl;
	m_solver->addAssertion(condition >= constantValue(1));

	ASTModifier::operator()(_if.body);

	m_solver->pop();

	// TODO if the body is non-continuing, we could assert that the condition is false
	// but this might not be true anymore once we join with another control-flow.
	// maybe it is best to let the conditional simplifier and the data flow analyzer do this for us.
}

void ReasoningBasedSimplifier::operator()(ForLoop& _for)
{
	// TODO handle break / continue

	if (!SideEffectsCollector{m_dialect, *_for.condition}.movable())
		return;

	cout << "Checking if condition  can be false" << endl;
	smtutil::Expression condition = encodeExpression(*_for.condition);
	m_solver->push();
	m_solver->addAssertion(condition <= constantValue(0));
	cout << "  running check" << endl;
	CheckResult result = m_solver->check({}).first;
	m_solver->pop();
	if (result == CheckResult::UNSATISFIABLE)
	{
		cout << " unsat => cannot be false!" << endl;
		Literal trueCondition = m_dialect.trueLiteral();
		trueCondition.debugData = debugDataOf(*_for.condition);
		_for.condition = make_unique<yul::Expression>(move(trueCondition));
	}
	else
	{
		cout << "Checking if condition  can be true" << endl;
		m_solver->push();
		m_solver->addAssertion(condition >= constantValue(1));
		cout << "  running check" << endl;
		CheckResult result2 = m_solver->check({}).first;
		m_solver->pop();
		if (result2 == CheckResult::UNSATISFIABLE)
		{
			cout << " unsat => cannot be true!" << endl;
			Literal falseCondition = m_dialect.zeroLiteralForType(m_dialect.boolType);
			falseCondition.debugData = debugDataOf(*_for.condition);
			_for.condition = make_unique<yul::Expression>(move(falseCondition));
			_for.body = yul::Block{};
			// Nothing left to be done.
			return;
		}
	}

	m_solver->push();
	cout << "Setting condition true inside body" << endl;
	m_solver->addAssertion(condition >= constantValue(1));

	ASTModifier::operator()(_for.body);
	ASTModifier::operator()(_for.post);

	m_solver->pop();
}

ReasoningBasedSimplifier::ReasoningBasedSimplifier(
	Dialect const& _dialect,
	set<YulString> const& _ssaVariables
):
	SMTSolver(_ssaVariables, _dialect),
	m_dialect(_dialect)
{
}


smtutil::Expression ReasoningBasedSimplifier::encodeEVMBuiltin(
	evmasm::Instruction _instruction,
	vector<yul::Expression> const& _arguments
)
{
	vector<smtutil::Expression> arguments = applyMap(
		_arguments,
		[this](yul::Expression const& _expr) { return encodeExpression(_expr); }
	);
	switch (_instruction)
	{
	case evmasm::Instruction::ADD:
	{
		auto result = arguments.at(0) + arguments.at(1) - (bigint(1) << 256) * newZeroOneVariable();
		restrictToEVMWord(result);
		return result;
	}
	case evmasm::Instruction::MUL:
		// TODO this only works will with the rematerializer.
		if (holds_alternative<Literal>(_arguments.at(0)) || holds_alternative<Literal>(_arguments.at(1)))
			return wrap(arguments.at(0) * arguments.at(1));
		else
			return newRestrictedVariable();
	case evmasm::Instruction::SUB:
	{
		auto result = arguments.at(0) - arguments.at(1) + (bigint(1) << 256) * newZeroOneVariable();
		restrictToEVMWord(result);
		return result;
	}
	case evmasm::Instruction::DIV:
		break;
		/*
		// TODO add assertion that result is <= input
		return smtutil::Expression::ite(
			arguments.at(1) == constantValue(0),
			constantValue(0),
			arguments.at(0) / arguments.at(1)
		);
		*/
	case evmasm::Instruction::SDIV:
		break;
		/*
		return smtutil::Expression::ite(
			arguments.at(1) == constantValue(0),
			constantValue(0),
			// No `wrap()` needed here, because -2**255 / -1 results
			// in 2**255 which is "converted" to its two's complement
			// representation 2**255 in `signedToTwosComplement`
			signedToTwosComplement(smtutil::signedDivisionEVM(
				twosComplementToUpscaledUnsigned(arguments.at(0)),
				twosComplementToUpscaledUnsigned(arguments.at(1))
			))
		);
		*/
	case evmasm::Instruction::MOD:
		break;
		/*
		return smtutil::Expression::ite(
			arguments.at(1) == constantValue(0),
			constantValue(0),
			arguments.at(0) % arguments.at(1)
		);
		*/
	case evmasm::Instruction::SMOD:
		break;
		/*
		return smtutil::Expression::ite(
			arguments.at(1) == constantValue(0),
			constantValue(0),
			signedToTwosComplement(signedModuloEVM(
				twosComplementToUpscaledUnsigned(arguments.at(0)),
				twosComplementToUpscaledUnsigned(arguments.at(1))
			))
		);
		*/
	case evmasm::Instruction::LT:
		return booleanValue(arguments.at(0) < arguments.at(1));
	case evmasm::Instruction::SLT:
		return booleanValue(
			twosComplementToUpscaledUnsigned(arguments.at(0)) + smtutil::Expression(bigint(1) << 256) <
			twosComplementToUpscaledUnsigned(arguments.at(1)) + smtutil::Expression(bigint(1) << 256)
		);
	case evmasm::Instruction::GT:
		return booleanValue(arguments.at(0) > arguments.at(1));
	case evmasm::Instruction::SGT:
		return booleanValue(
			twosComplementToUpscaledUnsigned(arguments.at(0)) + smtutil::Expression(bigint(1) << 256) >
			twosComplementToUpscaledUnsigned(arguments.at(1)) + smtutil::Expression(bigint(1) << 256)
		);
	case evmasm::Instruction::EQ:
		return booleanValue(arguments.at(0) == arguments.at(1));
	case evmasm::Instruction::ISZERO:
		return booleanValue(arguments.at(0) == constantValue(0));
	case evmasm::Instruction::AND:
	{
		smtutil::Expression result = newRestrictedVariable();
		m_solver->addAssertion(result <= arguments.at(0));
		m_solver->addAssertion(result <= arguments.at(1));
		// TODO can we say more?
		return result;
	}
	case evmasm::Instruction::OR:
		return smtutil::Expression::ite(
			arguments.at(0) + arguments.at(1) <= 2,
			booleanValue(arguments.at(0) + arguments.at(1) >= 1),
			// TODO we could probably restrict it a bit more
			newRestrictedVariable()
		);
	case evmasm::Instruction::XOR:
		break;
		//return bv2int(int2bv(arguments.at(0)) ^ int2bv(arguments.at(1)));
	case evmasm::Instruction::NOT:
		return smtutil::Expression(u256(-1)) - arguments.at(0);
	case evmasm::Instruction::SHL:
		return smtutil::Expression::ite(
			arguments.at(0) > 255,
			constantValue(0),
			newRestrictedVariable() // TODO bv2int(int2bv(arguments.at(1)) << int2bv(arguments.at(0)))
		);
	case evmasm::Instruction::SHR:
		return smtutil::Expression::ite(
			arguments.at(0) > 255,
			constantValue(0),
			newRestrictedVariable() // TODO bv2int(int2bv(arguments.at(1)) >> int2bv(arguments.at(0)))
		);
	case evmasm::Instruction::SAR:
		return smtutil::Expression::ite(
			arguments.at(0) > 255,
			constantValue(0),
			newRestrictedVariable() // TODO bv2int(smtutil::Expression::ashr(int2bv(arguments.at(1)), int2bv(arguments.at(0))))
		);
	case evmasm::Instruction::ADDMOD:
		break;
		/*
		return smtutil::Expression::ite(
			arguments.at(2) == constantValue(0),
			constantValue(0),
			(arguments.at(0) + arguments.at(1)) % arguments.at(2)
		);
		*/
	case evmasm::Instruction::MULMOD:
		break;
		/*
		return smtutil::Expression::ite(
			arguments.at(2) == constantValue(0),
			constantValue(0),
			(arguments.at(0) * arguments.at(1)) % arguments.at(2)
		);
		*/
	// TODO SIGNEXTEND
	default:
		break;
	}
	return newRestrictedVariable();
}

smtutil::Expression ReasoningBasedSimplifier::newZeroOneVariable()
{
	smtutil::Expression var = newVariable();
	m_solver->addAssertion(var <= 1);
	m_solver->addAssertion(var <= 0 || var >= 1);
	return var;
}

void ReasoningBasedSimplifier::restrictToEVMWord(smtutil::Expression _value)
{
	m_solver->addAssertion(0 <= _value && _value < bigint(1) << 256);
}
