library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity led_blink is
  port (
    i_clock     : in    std_ulogic; -- 25 MHz Clock
    i_reset     : in    std_ulogic; -- Reset signal
    i_enable    : in    std_ulogic; -- The Enable Switch (Logic 0 = No LED Drive)
    i_switch_1  : in    std_ulogic; -- Switch 1 in the Truth Table above
    i_switch_2  : in    std_ulogic; -- Switch 2 in the Truth Table above
    o_led_drive : out   std_ulogic  -- The signal that drives the LED
  );
end entity led_blink;

architecture rtl of led_blink is

  constant c_COUNTS_PER_100HZ : natural := 125_000;    -- The number of counts per 100Hz
  constant c_COUNTS_PER_50HZ  : natural := 250_000;    -- The number of counts per 50Hz
  constant c_COUNTS_PER_10HZ  : natural := 1_250_000;  -- The number of counts per 10Hz
  constant c_COUNTS_PER_1_HZ  : natural := 12_500_000; -- The number of counts per 1Hz

  signal r_counts_100hz : natural range 0 to c_COUNTS_PER_100HZ; -- Counter for 100Hz clock
  signal r_counts_50hz  : natural range 0 to c_COUNTS_PER_50HZ;  -- Counter for 50Hz clock
  signal r_counts_10hz  : natural range 0 to c_COUNTS_PER_10HZ;  -- Counter for 10Hz clock
  signal r_counts_1hz   : natural range 0 to c_COUNTS_PER_1HZ;   -- Counter for 1Hz clock

  signal r_is_active_100hz : std_ulogic; -- If the 100Hz clock is active
  signal r_is_active_50hz  : std_ulogic; -- If the 50Hz clock is active
  signal r_is_active_10hz  : std_ulogic; -- If the 10Hz clock is active
  signal r_is_active_1hz   : std_ulogic; -- If the 1Hz clock is active

  signal w_is_led_active : std_ulogic; -- If LED signal is active

begin

  -- Handles the 100Hz clock
  p_100hz : process (i_clock, i_reset) is
  begin

    if (i_reset = '1') then
      r_is_active_100hz <= '0';
      r_counts_100hz    <= 0;
    elsif rising_edge(i_clock) then
      if (r_counts_100hz = c_COUNTS_PER_100HZ - 1) then
        -- Toggle
        r_is_active_100hz <= not r_is_active_100hz;
        r_counts_100hz    <= 0;
      else
        -- Increment the counter
        r_counts_100hz <= r_counts_100hz + 1;
      end if;
    end if;

  end process p_100hz;

  -- Handles the 50Hz clock
  p_50hz : process (i_clock, i_reset) is
  begin

    if (i_reset = '1') then
      r_is_active_50hz <= '0';
      r_counts_50hz    <= 0;
    elsif rising_edge(i_clock) then
      if (r_counts_50hz = c_COUNTS_PER_50HZ - 1) then
        -- Toggle
        r_is_active_50hz <= not r_is_active_50hz;
        r_counts_50hz    <= 0;
      else
        -- Increment the counter
        r_counts_50hz <= r_counts_50hz + 1;
      end if;
    end if;

  end process p_50hz;

  -- Handles the 10Hz clock
  p_10hz : process (i_clock, i_reset) is
  begin

    if (i_reset = '1') then
      r_is_active_10hz <= '0';
      r_counts_10hz    <= 0;
    elsif rising_edge(i_clock) then
      if (r_counts_10hz = c_COUNTS_PER_10HZ - 1) then
        -- Toggle
        r_is_active_10hz <= not r_is_active_10hz;
        r_counts_10hz    <= 0;
      else
        -- Increment the counter
        r_counts_10hz <= r_counts_10hz + 1;
      end if;
    end if;

  end process p_10hz;

  -- Handles the 1Hz clock
  p_1hz : process (i_clock, i_reset) is
  begin

    if (i_reset = '1') then
      r_is_active_1hz <= '0';
      r_counts_1hz    <= 0;
    elsif rising_edge(i_clock) then
      if (r_counts_1hz = c_COUNTS_PER_1HZ - 1) then
        -- Toggle
        r_is_active_1hz <= not r_is_active_1hz;
        r_counts_1hz    <= 0;
      else
        -- Increment the counter
        r_counts_1hz <= r_counts_1hz + 1;
      end if;
    end if;

  end process p_1hz;

  w_is_led_active <= r_is_active_100hz when (i_switch_1 = '0' and i_switch_2 = '0') else
                     r_is_active_50hz when (i_switch_1 = '0' and i_switch_2 = '1') else
                     r_is_active_10hz when (i_switch_1 = '1' and i_switch_2 = '0') else
                     r_is_active_1hz;
  o_led_drive     <= i_enable and w_is_led_active;

end architecture rtl;
