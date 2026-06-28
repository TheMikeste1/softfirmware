library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity or4 is
  port (
    a : in    std_ulogic;
    b : in    std_ulogic;
    c : in    std_ulogic;
    d : in    std_ulogic;
    y : out   std_ulogic
  );
end entity or4;

architecture rtl of or4 is

begin
  y <= a or b or c or d;
end architecture rtl;
