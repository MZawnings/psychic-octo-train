contract C {
    function a() public pure returns (bool payable) {}
    function b() public pure returns (string payable) {}
    function c() public pure returns (int payable) {}
    function d() public pure returns (int256 payable) {}
    function e() public pure returns (uint payable) {}
    function f() public pure returns (uint256 payable) {}
    function g() public pure returns (bytes1 payable) {}
    function h() public pure returns (bytes payable) {}
    function i() public pure returns (bytes32 payable) {}
    function j() public pure returns (fixed payable) {}
    function k() public pure returns (fixed80x80 payable) {}
    function l() public pure returns (ufixed payable) {}
    function m() public pure returns (ufixed80x80 payable) {}
}
// ----
// ParserError 9106: (56-63='payable'): State mutability can only be specified for address types.
// ParserError 9106: (113-120='payable'): State mutability can only be specified for address types.
// ParserError 9106: (167-174='payable'): State mutability can only be specified for address types.
// ParserError 9106: (224-231='payable'): State mutability can only be specified for address types.
// ParserError 9106: (279-286='payable'): State mutability can only be specified for address types.
// ParserError 9106: (337-344='payable'): State mutability can only be specified for address types.
// ParserError 9106: (394-401='payable'): State mutability can only be specified for address types.
// ParserError 9106: (450-457='payable'): State mutability can only be specified for address types.
// ParserError 9106: (508-515='payable'): State mutability can only be specified for address types.
// ParserError 9106: (564-571='payable'): State mutability can only be specified for address types.
// ParserError 9106: (625-632='payable'): State mutability can only be specified for address types.
// ParserError 9106: (682-689='payable'): State mutability can only be specified for address types.
// ParserError 9106: (744-751='payable'): State mutability can only be specified for address types.
