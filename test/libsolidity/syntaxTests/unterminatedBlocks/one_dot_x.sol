contract test {
    function f() pure public { 1.x; }
}
// ----
// TypeError: (47-50): Member "x" not found or not visible after argument-dependent lookup in int_const 1.