struct S {
    uint x;
}

enum E {A, B, C}

contract C {
    function f() public pure {
        address(uint);
        address(bytes16);
        address(bool);
        address(address);
        address(fixed);

        address(S);
        address(E);

        address(uint[]);
        address(uint[][]);
        address(uint[5]);
        address(string);
        address(bytes);
        address(S[]);
        address(E[]);
        address((uint, uint));

        address(type(uint));
    }
}
// ----
// TypeError 9640: (96-109='address(uint)'): Explicit type conversion not allowed from "type(uint256)" to "address".
// TypeError 9640: (119-135='address(bytes16)'): Explicit type conversion not allowed from "type(bytes16)" to "address".
// TypeError 9640: (145-158='address(bool)'): Explicit type conversion not allowed from "type(bool)" to "address".
// TypeError 9640: (168-184='address(address)'): Explicit type conversion not allowed from "type(address)" to "address".
// TypeError 9640: (194-208='address(fixed)'): Explicit type conversion not allowed from "type(fixed128x18)" to "address".
// TypeError 9640: (219-229='address(S)'): Explicit type conversion not allowed from "type(struct S storage pointer)" to "address".
// TypeError 9640: (239-249='address(E)'): Explicit type conversion not allowed from "type(enum E)" to "address".
// TypeError 9640: (260-275='address(uint[])'): Explicit type conversion not allowed from "type(uint256[] memory)" to "address".
// TypeError 9640: (285-302='address(uint[][])'): Explicit type conversion not allowed from "type(uint256[] memory[] memory)" to "address".
// TypeError 9640: (312-328='address(uint[5])'): Explicit type conversion not allowed from "type(uint256[5] memory)" to "address".
// TypeError 9640: (338-353='address(string)'): Explicit type conversion not allowed from "type(string storage pointer)" to "address".
// TypeError 9640: (363-377='address(bytes)'): Explicit type conversion not allowed from "type(bytes storage pointer)" to "address".
// TypeError 9640: (387-399='address(S[])'): Explicit type conversion not allowed from "type(struct S memory[] memory)" to "address".
// TypeError 9640: (409-421='address(E[])'): Explicit type conversion not allowed from "type(enum E[] memory)" to "address".
// TypeError 9640: (431-452='address((uint, uint))'): Explicit type conversion not allowed from "tuple(type(uint256),type(uint256))" to "address".
// TypeError 9640: (463-482='address(type(uint))'): Explicit type conversion not allowed from "type(uint256)" to "address".
