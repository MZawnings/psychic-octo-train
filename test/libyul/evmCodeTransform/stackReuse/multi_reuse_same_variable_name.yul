{ let z := mload(0) { let x := 1 x := 6 z := x } { let x := 2 z := x x := 4 } }
// ====
// stackOptimization: true
// ----
//     /* "":17:18   */
//   0x00
//     /* "":11:19   */
//   mload
//   pop
//     /* "":31:32   */
//   pop(0x01)
//     /* "":38:39   */
//   pop(0x06)
//     /* "":60:61   */
//   pop(0x02)
//     /* "":74:75   */
//   pop(0x04)
//   stop
