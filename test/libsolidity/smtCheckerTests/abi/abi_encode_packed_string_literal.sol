contract C {
	function abiencodePackedStringLiteral() public pure {
		bytes memory b1 = abi.encodePacked("");
		bytes memory b2 = abi.encodePacked("");
		// should hold, but currently fails due to string literal abstraction
		assert(b1.length == b2.length);

		bytes memory b3 = abi.encodePacked(bytes(""));
		assert(b1.length == b3.length); // should fail

		bytes memory b4 = abi.encodePacked(bytes24(""));
		// should hold, but currently fails due to string literal abstraction
		assert(b1.length == b4.length);

		bytes memory b5 = abi.encodePacked(string(""));
		assert(b1.length == b5.length); // should fail

		bytes memory b6 = abi.encode("");
		assert(b1.length == b6.length); // should fail
	}
}
// ====
// SMTEngine: all
// SMTIgnoreOS: macos
// ----
// Warning 6328: (226-256): CHC: Assertion violation happens here.\nCounterexample:\n\nb1 = [0x42, 0x42, 0x42, 0x42, 0x42, 0x42, 0x42, 0x42, 0x42, 0x42, 0x42, 0x42, 0x42, 0x42, 0x42, 0x42, 0x42, 0x42, 0x42]\nb3 = []\nb4 = []\nb5 = []\nb6 = []\n\nTransaction trace:\nC.constructor()\nC.abiencodePackedStringLiteral()
// Warning 6328: (310-340): CHC: Assertion violation happens here.\nCounterexample:\n\nb2 = [0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72, 0x72]\nb4 = []\nb5 = []\nb6 = []\n\nTransaction trace:\nC.constructor()\nC.abiencodePackedStringLiteral()
// Warning 6328: (483-513): CHC: Assertion violation happens here.\nCounterexample:\n\nb5 = []\nb6 = []\n\nTransaction trace:\nC.constructor()\nC.abiencodePackedStringLiteral()
// Warning 6328: (568-598): CHC: Assertion violation happens here.\nCounterexample:\n\nb2 = [0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc]\nb6 = []\n\nTransaction trace:\nC.constructor()\nC.abiencodePackedStringLiteral()
// Warning 6328: (654-684): CHC: Assertion violation happens here.\nCounterexample:\n\nb3 = [0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a, 0x011a]\nb6 = [0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117, 0x0117]\n\nTransaction trace:\nC.constructor()\nC.abiencodePackedStringLiteral()
