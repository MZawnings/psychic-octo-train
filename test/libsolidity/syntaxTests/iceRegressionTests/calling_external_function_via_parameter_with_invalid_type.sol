contract C {
    function f(
        function() external returns (function() internal) getCallback
    ) public {
        getCallback();
    }
}
// ----
// TypeError 2582: (66-86='function() internal)'): Internal type cannot be used for external function type.
