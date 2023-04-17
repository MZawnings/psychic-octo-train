pragma experimental SMTChecker;

contract B {
	uint x = 5;
}

contract C is B {
	constructor() {
		assert(x == 5);
		x = 10;
	}

	function f(uint y) public view {
		assert(y == x);
	}
}
// ====
// SMTIgnoreCex: yes
// ----
// Warning 6328: (165-179): CHC: Assertion violation happens here.
