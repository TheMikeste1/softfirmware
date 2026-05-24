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

  constant counts_per_100hz : natural := 125_000;    -- The number of counts per 100Hz
  constant counts_per_50hz  : natural := 250_000;    -- The number of counts per 50Hz
  constant counts_per_10hz  : natural := 1_250_000;  -- The number of counts per 10Hz
  constant counts_per_1hz   : natural := 12_500_000; -- The number of counts per 1Hz

  signal counts_100hz : natural range 0 to counts_per_100hz; -- Counter for 100Hz clock
  signal counts_50hz  : natural range 0 to counts_per_50hz;  -- Counter for 50Hz clock
  signal counts_10hz  : natural range 0 to counts_per_10hz;  -- Counter for 10Hz clock
  signal counts_1hz   : natural range 0 to counts_per_1hz;   -- Counter for 1Hz clock

  signal is_active_100hz : std_ulogic; -- If the 100Hz clock is active
  signal is_active_50hz  : std_ulogic; -- If the 50Hz clock is active
  signal is_active_10hz  : std_ulogic; -- If the 10Hz clock is active
  signal is_active_1hz   : std_ulogic; -- If the 1Hz clock is active

  signal is_led_active : std_ulogic; -- If LED signal is active

begin

  -- Handles the 100Hz clock
  p_100hz : process (i_clock, i_reset) is
  begin

    if (i_reset = '1') then
      is_active_100hz <= '0';
      counts_100hz    <= 0;
    elsif rising_edge(i_clock) then
      if (counts_100hz = counts_per_100hz - 1) then
        -- Toggle
        is_active_100hz <= not is_active_100hz;
        counts_100hz    <= 0;
      else
        -- Increment the counter
        counts_100hz <= counts_100hz + 1;
      end if;
    end if;

  end process p_100hz;

  -- Handles the 50Hz clock
  p_50hz : process (i_clock, i_reset) is
  begin

    if (i_reset = '1') then
      is_active_50hz <= '0';
      counts_50hz    <= 0;
    elsif rising_edge(i_clock) then
      if (counts_50hz = counts_per_50hz - 1) then
        -- Toggle
        is_active_50hz <= not is_active_50hz;
        counts_50hz    <= 0;
      else
        -- Increment the counter
        counts_50hz <= counts_50hz + 1;
      end if;
    end if;

  end process p_50hz;

  -- Handles the 10Hz clock
  p_10hz : process (i_clock, i_reset) is
  begin

    if (i_reset = '1') then
      is_active_10hz <= '0';
      counts_10hz    <= 0;
    elsif rising_edge(i_clock) then
      if (counts_10hz = counts_per_10hz - 1) then
        -- Toggle
        is_active_10hz <= not is_active_10hz;
        counts_10hz    <= 0;
      else
        -- Increment the counter
        counts_10hz <= counts_10hz + 1;
      end if;
    end if;

  end process p_10hz;

  -- Handles the 1Hz clock
  p_1hz : process (i_clock, i_reset) is
  begin

    if (i_reset = '1') then
      is_active_1hz <= '0';
      counts_1hz    <= 0;
    elsif rising_edge(i_clock) then
      if (counts_1hz = counts_per_1hz - 1) then
        -- Toggle
        is_active_1hz <= not is_active_1hz;
        counts_1hz    <= 0;
      else
        -- Increment the counter
        counts_1hz <= counts_1hz + 1;
      end if;
    end if;

  end process p_1hz;

  is_led_active <= is_active_100hz when (i_switch_1 = '0' and i_switch_2 = '0') else
                   is_active_50hz when (i_switch_1 = '0' and i_switch_2 = '1') else
                   is_active_10hz when (i_switch_1 = '1' and i_switch_2 = '0') else
                   is_active_1hz;
  o_led_drive   <= i_enable and is_led_active;

end architecture rtl;
