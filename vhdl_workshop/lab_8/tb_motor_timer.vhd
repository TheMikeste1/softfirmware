library ieee;
  use std.textio.all;
  use ieee.std_logic_1164.all;

entity tb_motor_timer is
end entity tb_motor_timer;

architecture test of tb_motor_timer is
  constant PERIOD : time := 1 sec / 8192;

  component motor_timer is
    generic (
      g_tick_period : time
    );
    port (
      clk         : in    std_ulogic;
      reset       : in    std_ulogic;
      motor_go    : in    std_ulogic;
      motor_ready : in    std_ulogic;
      motor_error : out   std_ulogic
    );
  end component motor_timer;

  -- vsg_off signal_007
  signal w_clk : std_ulogic := '0';
  -- vsg_on signal_007
  signal w_reset       : std_ulogic;
  signal w_motor_go    : std_ulogic;
  signal w_motor_ready : std_ulogic;
  signal w_motor_error : std_ulogic;

begin

  -- vsg_off instantiation_034
  dut : component motor_timer
    generic map (

      g_tick_period => PERIOD
    )
    port map (
      clk         => w_clk,
      reset       => w_reset,
      motor_go    => w_motor_go,
      motor_ready => w_motor_ready,
      motor_error => w_motor_error
    );
  -- vsg_on instantiation_034

  w_clk <= not w_clk after PERIOD / 2;

  stimuli : process is
  begin
    w_reset       <= '1';
    w_motor_go    <= '1';
    w_motor_ready <= '0';
    wait for 3 * PERIOD;
    assert w_motor_error = '0';

    w_reset    <= '0';
    w_motor_go <= '0';
    wait for 2.1 sec;
    -- no changes
    assert w_motor_error = '0';

    w_motor_go <= '1';
    wait for PERIOD;
    w_motor_go <= '0';

    -- MOTOR_ERROR -> '1' -> '0'
    wait for 2 sec;
    assert w_motor_error = '1';

    wait until w_clk = '1';     -- Align to the clock
    wait for PERIOD / 2;        -- Wait just a moment so the signal can update
    assert w_motor_error = '0';

    w_motor_go    <= '1';
    wait for PERIOD;
    w_motor_go    <= '0';
    wait for 1.9 sec;
    w_motor_ready <= '1';
    wait for PERIOD;
    w_motor_ready <= '0';
    wait for 2.1 sec;
    assert w_motor_error = '0';

    std.env.finish;
  end process stimuli;

  sample : process (w_motor_go, w_motor_error) is
    constant SPACE     : string := " ";
    variable file_line : line;
    file     out_file  : TEXT open write_mode is "lab_8.trace";
  begin
    write(file_line, now);
    write(file_line, SPACE);
    write(file_line, to_bit(w_motor_go));
    write(file_line, SPACE);
    write(file_line, to_bit(w_motor_error));

    writeline(OUT_FILE, file_line);
  end process sample;
end architecture test;

configuration CFG_TB_MOTOR_TIMER of TB_MOTOR_TIMER is
  for TEST
  end for;
end CFG_TB_MOTOR_TIMER;
