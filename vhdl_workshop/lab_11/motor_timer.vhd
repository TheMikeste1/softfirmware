library ieee;
  use ieee.std_logic_1164.all;

entity motor_timer is
  generic (
    --! Period of time between ticks (clk high edge).
    g_tick_period : time
  );
  port (
    clk         : in    std_ulogic;
    reset       : in    std_ulogic;
    motor_go    : in    std_ulogic;
    motor_ready : in    std_ulogic;
    motor_error : out   std_ulogic
  );
begin
  assert g_tick_period > 0 sec;
end entity motor_timer;

architecture rtl of motor_timer is
  constant TIMEOUT_COUNT : natural := 2 sec / g_tick_period;

  signal w_counting : boolean;
begin

  -- Clocked process with asynchronous reset
  tick : process (reset, clk) is
    -- Variables for timeout counter value and counter active flag
    -- variable w_counting    : boolean;
    variable count_elasped : natural;
  begin
    if (reset = '1') then
      -- Reset values for all registers
      count_elasped := 0;
      w_counting    <= false;
      motor_error   <= '0';
    elsif (clk'event and clk = '1') then
      motor_error <= '0';

      if motor_go = '1' then
        -- Start timeout detector
        w_counting    <= true;
        count_elasped := 0;
      end if;

      if motor_ready = '1' then
        -- Stop timeout detector
        w_counting <= false;
      end if;
      -- elsif w_counting then
      if w_counting then
        -- Counter with overflow detection
        count_elasped := count_elasped + 1;
        if count_elasped >= TIMEOUT_COUNT then
          motor_error <= '1';
          w_counting  <= false;
        end if;
      end if;                                           -- if COUNTING
    end if;                                             -- end of clocked process
  end process tick;
end architecture rtl;
