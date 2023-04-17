pragma abicoder v2;

contract C {
    struct Data {
        uint256[] a;
        string b;
    }

    function f(Data calldata data, uint256[] calldata a) public pure returns (bytes memory) {
        // Make memory dirty (numbers come from trial & err)
        for (uint pos = 0x80; pos < 0x880; pos += 0x20)
            assembly {
                mstore(pos, not(0))
            }

        return abi.encode(data, a);
    }

    function g(Data memory data, uint256[] calldata a) public pure returns (bytes memory) {
        // Make memory dirty for string (0x126 is where the string ends)
        for (uint pos = 0x126; pos < 0x880; pos += 0x20)
            assembly {
                mstore(pos, not(0))
            }

        return abi.encode(data, a);
    }
}

// ====
// EVMVersion: >homestead
// ----
// f((uint256[],string),uint256[]): 0x40, 0x100, 0x40, 0x80, 1, 0xFF, 6, "123456XXX", 2, 0xAF, 0xBF -> 0x20, 0x0160, 0x40, 0x0100, 0x40, 0x80, 1, 0xff, 6, "123456", 2, 0xaf, 0xbf
// g((uint256[],string),uint256[]): 0x40, 0x100, 0x40, 0x80, 1, 0xFF, 6, "123456XXX", 2, 0xAF, 0xBF -> 0x20, 0x0160, 0x40, 0x0100, 0x40, 0x80, 1, 0xff, 6, "123456", 2, 0xaf, 0xbf
