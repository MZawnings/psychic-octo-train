contract C {
	uint[][] array2d;

	function l() public returns (uint) {
		return array2d.length;
	}

	function ll(uint index) public returns (uint) {
		return array2d[index].length;
	}

	function a(uint i, uint j) public returns (uint) {
		return array2d[i][j];
	}

	function f(uint index, uint value) public {
		uint[] storage pointer = array2d.push();
		for (uint i = 0; i <= index; ++i)
			pointer.push();
		pointer[index] = value;
	}

	function lv(uint value) public {
		array2d.push().push() = value;
	}
}
// ====
// compileViaYul: also
// ----
// l() -> 0
// f(uint256,uint256): 42, 64 ->
// gas irOptimized: 113236
// gas legacy: 108234
// gas legacyOptimized: 102245
// l() -> 1
// ll(uint256): 0 -> 43
// a(uint256,uint256): 0, 42 -> 64
// f(uint256,uint256): 84, 128 ->
// gas irOptimized: 117780
// gas legacy: 107780
// gas legacyOptimized: 96331
// l() -> 2
// ll(uint256): 1 -> 85
// a(uint256,uint256): 0, 42 -> 64
// a(uint256,uint256): 1, 84 -> 128
// lv(uint256): 512 ->
// a(uint256,uint256): 2, 0 -> 512
