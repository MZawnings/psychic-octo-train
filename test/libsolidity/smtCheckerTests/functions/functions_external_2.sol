pragma experimental SMTChecker;

abstract contract D
{
	function g(uint x) public virtual;
}

contract C
{
	mapping (uint => uint) map;
	function f(uint y, D d) public {
		require(map[0] == map[1]);
		assert(map[0] == map[1]);
		d.g(y);
		assert(map[0] == map[1]);
		assert(map[0] == 0); // should fail
	}

	function set(uint x) public {
		map[0] = x;
		map[1] = x;
	}
}
// ====
// SMTIgnoreCex: yes
// ----
// Warning 6328: (267-286): CHC: Assertion violation happens here.
