library ieee;
  use ieee.std_logic_1164.all;

entity abc is
  port (
    a : in    std_logic;
    b : in    std_logic;
    c : in    std_logic;
    y : out   std_logic
  );
end entity abc;

architecture synth of abc is
begin
  y <= (a and b) or (not b and c);
end architecture synth;

