contract C {
    function f() public pure
    {
        // RLO RLO
        bytes memory m = unicode"overflow ‮‮";
    }
}
// ----
// ParserError 8936: (92-115='unicode"overflow ‮‮'): Mismatching directional override markers in comment or string literal.
