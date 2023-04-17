pragma experimental SMTChecker;

contract C {
	mapping (uint => uint)[] public m;

	constructor() {
		m.push();
		m[0][1] = 42;
	}

	function f() public view {
		uint y = this.m(0,1);
		assert(y == m[0][1]); // should hold
		assert(y == 1); // should fail
	}
}
// ----
// Warning 6328: (225-239): CHC: Assertion violation happens here.\nCounterexample:\n\n\nTransaction trace:\nC.constructor()\nC.f()
