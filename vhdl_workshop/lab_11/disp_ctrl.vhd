library ieee;
  use ieee.std_logic_1164.all;
  use work.p_display.all;

entity disp_ctrl is
  port (
    clk       : in    std_ulogic;
    reset     : in    std_ulogic;
    key       : in    TDigits;
    switch    : in    std_ulogic;
    show_time : out   std_ulogic
  );
end entity disp_ctrl;

architecture rtl of disp_ctrl is
  -- Internal signal for SHOW_TIME output
  signal w_show_state : std_ulogic;
begin
  -- Output assignment
  show_time <= w_show_state;

  -- Clocked process with asynchronous reset
  tick : process (reset, clk) is
    variable last_switch : std_ulogic;
  begin
    if (reset = '1') then
      -- Reset all registers
      last_switch  := '0';
      w_show_state <= '0';
    elsif (clk'event and clk = '1') then
      if key /= (0, 0, 0) then
        w_show_state <= '1';
      else
        if last_switch = '0' and switch = '1' then
          w_show_state <= not w_show_state;
        end if;
      end if;

      -- Store the SWITCH value to allow a rising edge detection
      last_switch := switch;
    end if; -- end of clocked process
  end process tick;
end architecture rtl;
