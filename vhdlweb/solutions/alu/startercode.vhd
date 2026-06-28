library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity alu is
  port (
    a : in    unsigned(3 downto 0);
    b : in    unsigned(3 downto 0);
    s : in    std_logic_vector(1 downto 0);
    y : out   unsigned(3 downto 0)
  );
end entity alu;

architecture synth of alu is
begin
  y <= a and b when s = "00" else
       a or b when s = "01" else
       a + b when s = "10" else
       a - b when s = "11" else
       to_unsigned(0, y'length);
end architecture synth;
