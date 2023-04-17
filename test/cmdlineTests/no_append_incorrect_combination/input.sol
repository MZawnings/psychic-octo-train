pragma solidity >= 0.0.0;

contract C {
    function f() external {
        selfdestruct(payable(msg.sender));
    }
}
