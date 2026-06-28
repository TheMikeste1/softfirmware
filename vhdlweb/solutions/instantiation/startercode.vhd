library ieee;
  use ieee.std_logic_1164.all;

entity and4 is
  port (
    a : in    std_logic;
    b : in    std_logic;
    c : in    std_logic;
    y : out   std_logic
  );
end entity and4;

architecture synth of and4 is
  signal y_not : std_ulogic;
begin

  n : entity work.nand4(synth)
    port map (
      a => a,
      b => b,
      c => c,
      y => y_not
    );

  y <= not y_not;
end architecture synth;
