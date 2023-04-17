contract C {
    event Ev();
    error Er();

    function g0() internal {}
    function g1() internal returns (uint) { return (1); }
    function g2() internal returns (uint, uint) { return (2, 3); }

    function f0() public {}
    function f1(uint) public {}
    function f2(uint, uint) public {}

    function h() public view {
        uint a;
        uint b;

        abi.encodeCall(this.f0, true ? g0() : g0());
        abi.encodeCall(this.f1, true ? (1) : (2));
        abi.encodeCall(this.f1, true ? g1() : g1());
        abi.encodeCall(this.f2, true ? g2() : g2());
        abi.encodeCall(this.f2, true ? (1, 2) : (3, 4));

        abi.encodeCall(this.f1, (1) + (2));
        abi.encodeCall(this.f2, (1, 1) + (2, 2));

        abi.encodeCall(this.f1, (a) = g1());
        abi.encodeCall(this.f2, (a, b) = g2());

        abi.encodeCall(this.f0, Ev() / Er());

        abi.encodeCall(this.f0, !());
    }
}
// ----
// TypeError 9062: (397-415): Expected an inline tuple, not an expression of a tuple type.
// TypeError 9062: (554-572): Expected an inline tuple, not an expression of a tuple type.
// TypeError 9062: (607-629): Expected an inline tuple, not an expression of a tuple type.
// TypeError 2271: (709-724): Operator + not compatible with types tuple(int_const 1,int_const 1) and tuple(int_const 2,int_const 2)
// TypeError 9062: (709-724): Expected an inline tuple, not an expression of a tuple type.
// TypeError 9062: (805-818): Expected an inline tuple, not an expression of a tuple type.
// TypeError 2271: (854-865): Operator / not compatible with types tuple() and tuple()
// TypeError 9062: (854-865): Expected an inline tuple, not an expression of a tuple type.
// TypeError 4907: (901-904): Unary operator ! cannot be applied to type tuple()
// TypeError 9062: (901-904): Expected an inline tuple, not an expression of a tuple type.
