type MyInt is int;
contract C {
	function f() internal pure returns (MyInt a) {
	}
	function g() internal pure returns (MyInt b, MyInt c) {
		b = MyInt.wrap(int(1));
		c = MyInt.wrap(1);
	}

	function h() public pure {
		assert(MyInt.unwrap(f()) == 0);
		assert(MyInt.unwrap(f()) == 1); // should fail
		(MyInt x, MyInt y) = g();
		assert(MyInt.unwrap(x) == 1);
		assert(MyInt.unwrap(x) == 0); // should fail
		assert(MyInt.unwrap(y) == 1);
	}
}
// ====
// SMTEngine: all
// ----
// Warning 6328: (255-285): CHC: Assertion violation happens here.
// Warning 6328: (364-392): CHC: Assertion violation happens here.
// Info 1391: CHC: 3 verification condition(s) proved safe! Enable the model checker option "show proved safe" to see all of them.
