{
  sstore(0, staticcall(gas(), address(), 0, 0x20, 0x20, 0x20))
}
// ====
// EVMVersion: >=byzantium
// ----
// Trace:
//   STATICCALL()
// Memory dump:
//     20: 0000000000000000000000000000000000000000000000000000000000000001
// Storage dump:
//   0000000000000000000000000000000000000000000000000000000000000000: 0000000000000000000000000000000000000000000000000000000000000001
