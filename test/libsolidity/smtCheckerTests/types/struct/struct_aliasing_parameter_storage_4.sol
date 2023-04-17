contract C {
    struct S {
        mapping(address => uint) innerM;
		uint sum;
    }

	struct T {
		uint x;
		S s;
	}

	function f(S storage m, address i, uint v) internal {
		m.innerM[i] = v;
		m.sum += v;
	}

	T t;

	constructor(uint amt) {
		f(t.s, msg.sender, amt);
	}
	function g() public view {
		assert(t.s.sum == 0); // should hold but no aliasing support means it fails for now
	}
}
// ====
// SMTEngine: all
// ----
// Warning 6328: (305-325): CHC: Assertion violation happens here.\nCounterexample:\nt = {x: 10, s: {innerM, sum: 21239}}\n\nTransaction trace:\nC.constructor(0){ msg.sender: 0x6dc4 }\nState: t = {x: 10, s: {innerM, sum: 21239}}\nC.g()
