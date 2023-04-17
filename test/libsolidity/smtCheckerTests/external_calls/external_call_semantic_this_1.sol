contract C {
	uint x;
	function i() public { ++x; }
	function f() public {
		x = 0;
		this.i();
		assert(x == 1); // should hold in trusted mode
		assert(x != 1); // should fail
	}
}
// ====
// SMTEngine: chc
// SMTExtCalls: trusted
// SMTTargets: assert
// SMTIgnoreCex: yes
// ----
// Warning 6328: (147-161): CHC: Assertion violation happens here.
