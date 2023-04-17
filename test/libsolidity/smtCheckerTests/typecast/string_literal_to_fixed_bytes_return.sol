pragma experimental SMTChecker;
contract C {
    function g() public pure returns (bytes32 val) { return "abc"; }
    function f1() public pure returns (bytes32 val) { return g(); }

	function a() public pure {
		assert(f1() == "abc");
		assert(f1() == "cde");
	}
}
// ----
// Warning 6328: (238-259): CHC: Assertion violation happens here.\nCounterexample:\n\n\nTransaction trace:\nC.constructor()\nC.a()\n    C.f1() -- internal call\n        C.g() -- internal call\n    C.f1() -- internal call\n        C.g() -- internal call
