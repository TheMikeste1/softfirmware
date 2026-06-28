library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity saturatingadd is
  port (
    a      : in    unsigned(7 downto 0);
    b      : in    unsigned(7 downto 0);
    result : out   unsigned(7 downto 0)
  );
end entity saturatingadd;

architecture synth of saturatingadd is
  constant MAX : unsigned(7 downto 0) := (others => '1');
begin
  -- This likely wouldn't be as efficient as the gold version
  result <= MAX when (MAX - a) < b else
            a + b;
end architecture synth;
