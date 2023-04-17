library L {
    function g() external {}
}
contract C {
    function f() public returns (bytes memory) {
        (bool success, bytes memory result) = address(L).call(abi.encodeWithSignature("g()"));
		assert(!success);
		return result;
    }
}
// ====
// compileViaYul: also
// EVMVersion: >=byzantium
// revertStrings: debug
// ----
// library: L
// f() -> 32, 132, 3963877391197344453575983046348115674221700746820753546331534351508065746944, 862718293348820473429344482784628181556388621521298319395315527974912, 1518017211910606845658622928256476421055725129218887721595913401102969, 14649601406562900601407788686537400806574002225747213573947654179243427889152, 0
