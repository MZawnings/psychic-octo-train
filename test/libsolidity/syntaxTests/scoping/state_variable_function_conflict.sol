contract C {
    uint public f = 0;
    function f(uint) public pure {}
}
// ----
// DeclarationError 2333: (40-71='function f(uint) public pure {}'): Identifier already declared.
