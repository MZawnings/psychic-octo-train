contract C {
    function g0() internal {}
    function g1() internal returns (uint) { return (1); }
    function g2() internal returns (uint, uint) { return (2, 3); }

    function f0() public {}
    function f1(uint) public {}
    function f2(uint, uint) public {}

    function h() public view {
        abi.encodeCall(this.f0, g0());
        abi.encodeCall(this.f1, g1());
        abi.encodeCall(this.f2, g2());

        abi.encodeCall(this.f0, (g0()));
        abi.encodeCall(this.f1, (g1()));
        abi.encodeCall(this.f2, (g2()));
    }
}
// ----
// TypeError 9062: (331-335): Expected an inline tuple, not an expression of a tuple type.
// TypeError 9062: (409-413): Expected an inline tuple, not an expression of a tuple type.
// TypeError 6473: (450-454): Tuple component cannot be empty.
// TypeError 7788: (425-456): Expected 0 instead of 1 components for the tuple parameter.
// TypeError 7788: (507-538): Expected 2 instead of 1 components for the tuple parameter.
// TypeError 5407: (532-536): Cannot implicitly convert component at position 0 from "tuple(uint256,uint256)" to "uint256".
