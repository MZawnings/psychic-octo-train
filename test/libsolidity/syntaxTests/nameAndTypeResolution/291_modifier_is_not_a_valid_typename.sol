contract test {
    modifier mod() { _; }

    function f() public {
        mod g;
    }
}
// ----
// TypeError 5172: (77-80='mod'): Name has to refer to a struct, enum or contract.
