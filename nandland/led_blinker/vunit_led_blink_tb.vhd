library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

library vunit_lib;
  context vunit_lib.vunit_context;

entity led_blink_tb is
  generic (
    runner_cfg : string
  );
end entity led_blink_tb;

architecture behave of led_blink_tb is

  -- 25 MHz = 40 nanoseconds period
  constant c_clock_period : time := 40 ns;

  -- vsg_off signal_007
  signal clock_run   : boolean    := true;
  signal r_clock     : std_ulogic := '0';
  signal r_reset     : std_ulogic := '1';
  signal r_enable    : std_ulogic := '0';
  signal r_switch_1  : std_ulogic := '0';
  signal r_switch_2  : std_ulogic := '0';
  signal w_led_drive : std_ulogic;
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

  -- Separate concurrent process outside main
  clk_proc : process is
  begin

    while clock_run loop

      r_clock <= '0';
      wait for c_clock_period / 2;
      r_clock <= '1';
      wait for c_clock_period / 2;

    end loop;

    wait;

  end process clk_proc;

  main : process is
  begin

    test_runner_setup(runner, runner_cfg);

    while test_suite loop

      if run("100Hz blink") then
        r_reset  <= '0';
        r_enable <= '1';

        r_switch_1 <= '0';
        r_switch_2 <= '0';

        check_equal(w_led_drive, '0');

        for i in 0 to 125_000 loop

          check_equal(w_led_drive, '0');
          wait until rising_edge(r_clock);

        end loop;

        check_equal(w_led_drive, '1');
      end if;

    end loop;

    test_runner_cleanup(runner);

  end process main;

end architecture behave;
