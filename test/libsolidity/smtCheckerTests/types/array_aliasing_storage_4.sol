pragma experimental SMTChecker;

contract C
{
	uint[] array;
	uint[][] array2d;
	function f(uint[] storage a, uint[] storage b) internal {
		a[0] = 2;
		b[0] = 42;
		array[0] = 1;
		// Fails because array == a is possible.
		assert(a[0] == 2);
		// Fails because array == b is possible.
		assert(b[0] == 42);
		assert(array[0] == 1);
	}
	function g(uint x, uint y) public {
		f(array2d[x], array2d[y]);
	}
}
// ====
// SMTIgnoreCex: yes
// ----
// Warning 6328: (225-242): CHC: Assertion violation happens here.
// Warning 6328: (289-307): CHC: Assertion violation happens here.
