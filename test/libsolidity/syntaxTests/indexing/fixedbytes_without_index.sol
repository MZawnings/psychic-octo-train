contract C {
  function f() public {
    bytes32 b;
    b[];
  }
}
// ----
// TypeError 8830: (56-59='b[]'): Index expression cannot be omitted.
