contract C {
  bool state = true;

  function f() public {
    if (tx.gasprice > 0)
      state = false;
  }

  function scfuzzer_state() public returns (bool) {
    return state;
  }
}
