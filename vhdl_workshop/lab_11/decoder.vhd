library ieee;
  use ieee.std_logic_1164.all;
  use work.p_display.all;

entity decoder is
  port (
    keypad : in    std_ulogic_vector(9 downto 0);
    key    : out   TDigits
  );
end entity decoder;

