contract TransferTest {
	function() external payable {
		// This used to cause an ICE
		address(this).transfer;
	}

	function f() pure public {}
}
// ====
// compileViaYul: also
// ----
// f() ->
