library ieee;
  use ieee.std_logic_1164.all;

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

  tick : process (clk) is
  begin
    if (reset = '1') then
    -- Assign a default value
    elsif (clk'event and clk = '1') then
    -- Check for new input values
    end if;
  end process tick;
end architecture rtl;

