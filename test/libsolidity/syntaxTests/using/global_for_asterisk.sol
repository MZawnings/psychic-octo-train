using {f} for * global;
function f(uint) pure{}
// ----
// SyntaxError 8118: (0-23='using {f} for * global;'): The type has to be specified explicitly at file level (cannot use '*').
// SyntaxError 2854: (0-23='using {f} for * global;'): Can only globally bind functions to specific types.
