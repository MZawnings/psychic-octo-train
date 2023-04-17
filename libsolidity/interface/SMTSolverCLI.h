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
// SPDX-License-Identifier: GPL-3.0
#pragma once

#include <libsolidity/interface/ReadFile.h>

#include <boost/filesystem.hpp>

namespace solidity::frontend
{

class SMTSolverCLI
{
public:
	SMTSolverCLI(std::string _solverCmd);

	/// Receives a @p _sourceUnitName that refers to a source unit in compiler's virtual filesystem
	/// and attempts to interpret it as a path and read the corresponding file from disk.
	/// The read will only succeed if the canonical path of the file is within one of the @a allowedDirectories().
	/// @param _kind must be equal to "source". Other values are not supported.
	/// @return Content of the loaded file or an error message. If the operation succeeds, a copy of
	/// the content is retained in @a sourceUnits() under the key of @a _sourceUnitName. If the key
	/// already exists, previous content is discarded.
	frontend::ReadCallback::Result solve(std::string const& _kind, std::string const& _query);

	frontend::ReadCallback::Callback solver()
	{
		return [this](std::string const& _kind, std::string const& _query) { return solve(_kind, _query); };
	}

private:
	std::string const m_solverCmd;
};

}
