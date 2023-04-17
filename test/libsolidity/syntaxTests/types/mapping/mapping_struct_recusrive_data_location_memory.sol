pragma abicoder               v2;
contract C {
    struct S { mapping(uint => uint) a; }
    struct T { S s; }
    struct U { T t; }
    function f(U memory) public {}
}
// ----
// TypeError 4103: (148-156='U memory'): Types containing (nested) mappings can only be parameters or return variables of internal or library functions.
