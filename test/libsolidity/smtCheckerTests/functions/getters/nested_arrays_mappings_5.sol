contract C {
	mapping (uint => mapping (uint => uint[][])) public m;

	constructor() {
		m[0][1].push();
		m[0][1].push();
		m[0][1].push();
		m[0][1][2].push();
		m[0][1][2].push();
		m[0][1][2].push();
		m[0][1][2].push();
		m[0][1][2][3] = 42;
	}

	function f() public view {
		uint y = this.m(0,1,2,3);
		assert(y == m[0][1][2][3]); // should hold
		assert(y == 1); // should fail
	}
}
// ====
// SMTEngine: all
// SMTIgnoreCex: yes
// ----
// Warning 6328: (354-368): CHC: Assertion violation happens here.
// Info 1180: Contract invariant(s) for :C:\n!(m[0][1].length <= 2)\n!(m[0][1][2].length <= 3)\n
