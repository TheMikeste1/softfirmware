library ieee;
  use ieee.std_logic_1164.all;

entity nand3 is
  port (
    a : in    std_logic;
    b : in    std_logic;
    c : in    std_logic;
    y : out   std_logic
  );
end entity nand3;

architecture synth of nand3 is
begin
  y <= not (a and b and c);
end architecture synth;
