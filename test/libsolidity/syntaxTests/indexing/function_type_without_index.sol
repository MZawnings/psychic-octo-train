contract C {
  function f() public {
    f[];
  }
}
// ----
// TypeError 2614: (41-42='f'): Indexed expression has to be a type, mapping or array (is function ())
