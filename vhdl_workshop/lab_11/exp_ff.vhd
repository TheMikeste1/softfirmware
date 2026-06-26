library ieee;
  use ieee.std_logic_1164.all;
  use work.p_display.TDigits;

entity exp_ff is
  port (
    clk      : in    std_ulogic;
    reset    : in    std_ulogic;
    key      : in    TDigits;
    exp_time : out   TDigits
  );
end entity exp_ff;

architecture rtl of exp_ff is
begin

  tick : process (clk, reset) is
  begin
    if (reset = '1') then
      -- Assign a default value
      exp_time <= (0, 0, 1);
    elsif rising_edge(clk) then
      -- Check for new input values
      if key /= (0, 0, 0) then
        exp_time <= key;
      end if;
    end if;
  end process tick;
end architecture rtl;
