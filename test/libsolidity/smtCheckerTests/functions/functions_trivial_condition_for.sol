contract C
{
	function f(bool x) public pure { require(x); for (;x;) {} }
}
// ====
// SMTEngine: all
// ----
// Warning 6838: (65-66='x'): BMC: Condition is always true.
