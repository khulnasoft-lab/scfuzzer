contract C {
    uint internal x;
    function set(uint _x) public {
        x = _x;
    }

    function scfuzzer_large() public returns (bool) {
        return (x+1 != 0);

    }
}
