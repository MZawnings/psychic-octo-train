contract C {
    uint immutable x = 0;
    uint y = x;
}
// ----
// TypeError 7733: (52-53='x'): Immutable variables cannot be read before they are initialized.
