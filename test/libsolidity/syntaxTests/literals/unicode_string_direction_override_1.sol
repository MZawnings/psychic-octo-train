contract C {
    function f() public pure
    {
        // PDF
        bytes memory s = unicode"underflow ‬";
    }
}
// ----
// ParserError 8936: (88-106='unicode"underflow'): Unicode direction override underflow in comment or string literal.
