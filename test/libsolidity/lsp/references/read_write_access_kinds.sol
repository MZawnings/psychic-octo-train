// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0;

import {RGBColor as ThatColor} from "../goto/lib.sol";

contract C
{
    function other() public pure returns (ThatColor memory output)
                                                      //   ^^^^^^ @OutputDef
    {
        output.red = 50;
    //  ^^^^^^ @OutputWrite1
    //     ^ @OutputWrite
        output.green = output.red;
    //  ^^^^^^ @OutputWrite2
    //                 ^^^^^^ @OutputRead1
    //         ^ @GreenWrite
        output.blue = output.green;
    //  ^^^^^^ @OutputWrite3
    //                 ^^^^^^ @OutputRead2
        //                   ^ @GreenUse
    }
}

// ----
// lib: @diagnostics 2072
// -> textDocument/documentHighlight {
//     "position": @OutputWrite
// }
// <- [
//     {
//         "kind": 3,
//         "range": @OutputDef
//     },
//     {
//         "kind": 3,
//         "range": @OutputWrite1
//     },
//     {
//         "kind": 3,
//         "range": @OutputWrite2
//     },
//     {
//         "kind": 2,
//         "range": @OutputRead1
//     },
//     {
//         "kind": 3,
//         "range": @OutputWrite3
//     },
//     {
//         "kind": 2,
//         "range": @OutputRead2
//     }
// ]
// -> textDocument/documentHighlight {
//     "position": @GreenWrite
// }
// <- [
//     {
//         "kind": 3,
//         "range": {
//             "end": {
//                 "character": 20,
//                 "line": 11
//             },
//             "start": {
//                 "character": 8,
//                 "line": 11
//             }
//         }
//     },
//     {
//         "kind": 2,
//         "range": {
//             "end": {
//                 "character": 34,
//                 "line": 13
//             },
//             "start": {
//                 "character": 22,
//                 "line": 13
//             }
//         }
//     }
// ]
// -> textDocument/documentHighlight {
//     "position": @GreenUse
// }
// <- [
//     {
//         "kind": 3,
//         "range": {
//             "end": {
//                 "character": 20,
//                 "line": 11
//             },
//             "start": {
//                 "character": 8,
//                 "line": 11
//             }
//         }
//     },
//     {
//         "kind": 2,
//         "range": {
//             "end": {
//                 "character": 34,
//                 "line": 13
//             },
//             "start": {
//                 "character": 22,
//                 "line": 13
//             }
//         }
//     }
// ]
