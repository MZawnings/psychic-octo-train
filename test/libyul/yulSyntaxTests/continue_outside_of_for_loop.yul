{
	let x:bool
	if x { continue }
}
// ====
// dialect: evmTyped
// ----
// SyntaxError 2592: (22-30='continue'): Keyword "continue" needs to be inside a for-loop body.
