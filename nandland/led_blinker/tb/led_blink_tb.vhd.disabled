library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity led_blink_tb is
end entity led_blink_tb;

architecture behave of led_blink_tb is

  -- 25 MHz = 40 nanoseconds period
  constant c_clock_period : time := 40 ns;

  -- vsg_off signal_007
  signal clock_run   : boolean   := true;
  signal r_clock     : std_logic := '0';
  signal r_reset     : std_logic := '1';
  signal r_enable    : std_logic := '0';
  signal r_switch_1  : std_logic := '0';
  signal r_switch_2  : std_logic := '0';
  signal w_led_drive : std_logic;
  -- vsg_on signal_007

  -- Component declaration for the Unit Under Test (UUT)
  component led_blink is
    port (
      i_clock     : in    std_logic;
      i_reset     : in    std_logic;
      i_enable    : in    std_logic;
      i_switch_1  : in    std_logic;
      i_switch_2  : in    std_logic;
      o_led_drive : out   std_logic
    );
  end component led_blink;

begin

  -- Instantiate the Unit Under Test (UUT)
  uut : component led_blink
    port map (
      i_clock     => r_clock,
      i_reset     => r_reset,
      i_enable    => r_enable,
      i_switch_1  => r_switch_1,
      i_switch_2  => r_switch_2,
      o_led_drive => w_led_drive
    );

  p_clk_gen : process is
  begin

    if (clock_run) then
      wait for c_clock_period / 2;
      r_clock <= not r_clock;
    else
      wait; -- Should terminate since the clock has stopped
    end if;

  end process p_clk_gen;

  main_testing : process is
  begin

    r_reset <= '0';
    r_enable <= '1';

    r_switch_1 <= '0';
    r_switch_2 <= '0';
    wait for 0.2 sec;

    r_switch_1 <= '0';
    r_switch_2 <= '1';
    wait for 0.2 sec;

    r_switch_1 <= '1';
    r_switch_2 <= '0';
    wait for 0.5 sec;

    r_switch_1 <= '1';
    r_switch_2 <= '1';
    wait for 2 sec;

    report "Tests completed, stopping simulation.";
    -- VHDL 2008
    -- stop; -- or finish;
    -- assert false
    --   report "Simulation Finished Successfully!"
    --   severity failure;
    clock_run <= false;
    wait;

  end process main_testing;

end architecture behave;
