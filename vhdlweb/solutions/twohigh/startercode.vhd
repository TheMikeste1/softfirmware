library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity twohigh is
  port (
    clk   : in    std_logic;
    input : in    std_logic;
    two   : out   std_logic
  );
end entity twohigh;

architecture synth of twohigh is
  signal r_prev_was_high : std_ulogic := '0';
begin

  tick : process (clk) is
  begin
    if rising_edge(clk) then
      two             <= '0';
      r_prev_was_high <= '0';
      if input = '1' then
        r_prev_was_high <= '1';
        two             <= r_prev_was_high;
      end if;
    end if;
  end process tick;
end architecture synth;
