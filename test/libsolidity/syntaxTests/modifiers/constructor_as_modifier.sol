contract C {
    constructor() C() {}
}
// ----
// TypeError 4659: (31-34='C()'): Referenced declaration is neither modifier nor base class.
