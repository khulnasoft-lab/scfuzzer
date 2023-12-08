contract C {
  uint fd;
  uint ft;
  uint gd;
  uint gt;

  function f() public {
      fd = block.number; 
      ft = block.timestamp;
  }
  function g() payable public {
      gd = block.number; 
      gt = block.timestamp;
  }

  function scfuzzer_block_number() public returns (bool) {
      return (fd - gd) != 42;
  }

  function scfuzzer_timestamp() public returns (bool) {
      return (ft - gt) != 43;
  }
} 
