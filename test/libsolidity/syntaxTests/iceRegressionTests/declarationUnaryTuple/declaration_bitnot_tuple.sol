contract C
{
    function f() public
    {
        int x = ~(0,);
    }
}
// ----
// TypeError 8381: (60-64='(0,)'): Tuple component cannot be empty.
