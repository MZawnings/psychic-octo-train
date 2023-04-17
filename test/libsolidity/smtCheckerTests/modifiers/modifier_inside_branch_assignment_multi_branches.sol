pragma experimental SMTChecker;

contract C {
	uint x;
	address owner;

	modifier onlyOwner {
		if (msg.sender == owner) {
			require(x > 0);
			_;
		}
	}

	function f() public onlyOwner {
		x -= 1;
		h();
	}
	function h() public onlyOwner {
		require(x < 10000);
		x += 2;
	}
	function g(uint y) public {
		require(y > 0 && y < 10000);
		require(msg.sender == owner);
		x = y;
		if (y > 1) {
			f();
			// This now fails as a false positive because
			// CHC does not propagate msg.sender throughout predicates.
			assert(x == y + 1);
		}
		// Fails for {y = 0, x = 0}.
		assert(x == 0);
	}
}
// ----
// Warning 6328: (573-587): CHC: Assertion violation happens here.
