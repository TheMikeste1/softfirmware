-- vsg_off signal_007
-- vsg_off instantiation_034

library ieee;
  use std.textio.all;
  use ieee.std_logic_1164.all;
  use work.ctrl.all;

entity tb_main_ctrl is
end entity tb_main_ctrl;

architecture test of tb_main_ctrl is
  constant PERIOD : time := 10 ns;

  component main_ctrl is
    port (
      clk         : in    std_ulogic;
      reset       : in    std_ulogic;
      trigger     : in    std_ulogic;
      expose      : in    std_ulogic;
      motor_ready : in    std_ulogic;
      motor_error : in    std_ulogic;
      i_error     : out   std_ulogic;
      timer_go    : out   std_ulogic;
      motor_go    : out   std_ulogic;
      state       : out   TState
    );
  end component main_ctrl;

  signal w_clk         : std_ulogic := '0';
  signal w_reset       : std_ulogic;
  signal w_trigger     : std_ulogic;
  signal w_expose      : std_ulogic;
  signal w_motor_ready : std_ulogic;
  signal w_motor_error : std_ulogic;
  signal w_error       : std_ulogic;
  signal w_timer_go    : std_ulogic;
  signal w_motor_go    : std_ulogic;
  signal w_state       : TState;

begin

  dut : component main_ctrl
    port map (
      clk         => w_clk,
      reset       => w_reset,
      trigger     => w_trigger,
      expose      => w_expose,
      motor_ready => w_motor_ready,
      motor_error => w_motor_error,
      i_error     => w_error,
      timer_go    => w_timer_go,
      motor_go    => w_motor_go,
      state       => w_state
    );

  w_clk <= not w_clk after PERIOD / 2;

  stimuli : process is
  begin
    w_reset       <= '1';
    w_trigger     <= '1';
    w_motor_ready <= '0';
    w_motor_error <= '1';
    wait for 3 * PERIOD;
    assert w_timer_go = '0';
    assert w_motor_go = '0';
    assert w_state = Idle;

    w_reset       <= '0';
    w_trigger     <= '0';
    w_motor_ready <= '0';
    w_motor_error <= '0';
    wait for 10 * PERIOD;
    assert w_timer_go = '0';
    assert w_motor_go = '0';
    assert w_state = Idle;

    w_trigger <= '1';
    wait for PERIOD;
    w_trigger <= '0';
    assert w_timer_go = '1';
    assert w_motor_go = '0';
    assert w_state = TakePic;
    wait for 1 * PERIOD;
    assert w_timer_go = '0';
    assert w_motor_go = '0';
    assert w_state = DelayTakePic;
    wait for 1 * PERIOD;
    assert w_timer_go = '0';
    assert w_motor_go = '0';
    assert w_state = WaitExpTime;
    wait for 10 * PERIOD;
    assert w_timer_go = '0';
    assert w_motor_go = '1';
    assert w_state = DelayMotor;
    wait for 1 * PERIOD;
    assert w_timer_go = '0';
    assert w_motor_go = '0';
    assert w_state = WaitMotor;

    w_trigger <= '1';
    wait for PERIOD;
    assert w_timer_go = '0';
    assert w_motor_go = '0';
    assert w_state = WaitMotor;
    w_trigger <= '0';
    wait for 5 * PERIOD;
    assert w_timer_go = '0';
    assert w_motor_go = '0';
    assert w_state = WaitMotor;

    w_motor_ready <= '1';
    wait for PERIOD;
    assert w_timer_go = '0';
    assert w_motor_go = '0';
    assert w_state = Idle;
    w_motor_ready <= '0';
    wait for 5 * PERIOD;
    assert w_timer_go = '0';
    assert w_motor_go = '0';
    assert w_state = Idle;

    w_trigger <= '1';
    wait for 15 * PERIOD;

    w_motor_ready <= '1';
    wait for PERIOD;
    assert w_state = TakePic;
    w_motor_ready <= '0';
    wait for 15 * PERIOD;

    w_motor_ready <= '1';
    wait for PERIOD;
    assert w_state = TakePic;
    w_motor_ready <= '0';
    wait for 15 * PERIOD;

    w_motor_ready <= '1';
    wait for PERIOD;
    assert w_state = TakePic;
    w_motor_ready <= '0';
    wait for 15 * PERIOD;

    w_motor_error <= '1';
    wait for PERIOD;
    assert w_error = '1';
    assert w_state = Broken;
    w_motor_error <= '0';
    -- w_trigger     <= '1'; trigger already high
    wait for 1 * PERIOD;
    assert w_error = '0';
    assert w_state = Recovery;
    w_trigger <= '0';
    wait for 15 * PERIOD;
    assert w_error = '0';
    assert w_state = Idle;

    std.env.finish;
  end process stimuli;

  sample : process (w_trigger, w_expose, w_motor_ready, w_motor_error,
                    w_error, w_timer_go, w_motor_go) is
    constant SPACE     : string := " ";
    variable file_line : line;
    file     out_file  : TEXT open write_mode is "lab_10.trace";
  begin
    write(file_line, now);
    write(file_line, SPACE);
    write(file_line, to_bit(w_trigger));
    write(file_line, to_bit(w_expose));
    write(file_line, to_bit(w_motor_ready));
    write(file_line, to_bit(w_motor_error));
    write(file_line, SPACE);
    write(file_line, to_bit(w_error));
    write(file_line, SPACE);
    write(file_line, to_bit(w_timer_go));
    write(file_line, SPACE);
    write(file_line, to_bit(w_motor_go));
    writeline(OUT_FILE, file_line);
  end process sample;

  timer : process is
  begin
    w_expose <= '0';
    wait until w_timer_go'EVENT and w_timer_go = '1' and w_reset = '0';

    wait for PERIOD;
    w_expose <= '1';
    wait for 10 * PERIOD;
    w_expose <= '0';
  end process timer;
end architecture test;

configuration CFG_TB_MAIN_CTRL of TB_MAIN_CTRL is
  for TEST
  end for;
end CFG_TB_MAIN_CTRL;
