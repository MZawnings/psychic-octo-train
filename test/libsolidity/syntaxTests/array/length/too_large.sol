contract C {
    uint[8**90] ids;
}
// ----
// TypeError 5462: (22-27='8**90'): Invalid array length, expected integer literal or constant expression.
