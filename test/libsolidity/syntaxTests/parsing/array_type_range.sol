contract C {
    function f() public pure {
        uint[][1:] memory x;
        uint[][1:2] memory x;
        uint[1:] memory x;
        uint[1:2] memory x;
    }
}

// ----
// ParserError 5464: (52-62='uint[][1:]'): Expected array length expression.
// ParserError 5464: (81-92='uint[][1:2]'): Expected array length expression.
// ParserError 5464: (111-119='uint[1:]'): Expected array length expression.
// ParserError 5464: (138-147='uint[1:2]'): Expected array length expression.
