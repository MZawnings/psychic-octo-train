{ let x := 1 x := 6 { let y := 2 y := 4 } }
// ====
// stackOptimization: true
// ----
//     /* "":11:12   */
//   pop(0x01)
//     /* "":18:19   */
//   pop(0x06)
//     /* "":31:32   */
//   pop(0x02)
//     /* "":38:39   */
//   pop(0x04)
//   stop
