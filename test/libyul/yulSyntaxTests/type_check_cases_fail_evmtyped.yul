{
    switch 7
    case true:bool {}
    case true:bool {}
}
// ====
// dialect: evmTyped
// ----
// TypeError 3781: (24-33='true:bool'): Expected a value of type "u256" but got "bool".
// TypeError 3781: (46-55='true:bool'): Expected a value of type "u256" but got "bool".
