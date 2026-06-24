-- vsg_off signal_007
-- vsg_off instantiation_034

library ieee;
  use ieee.std_logic_1164.all;
  use work.p_display.all;

entity tb_exp_ctrl is
end entity tb_exp_ctrl;

architecture test of tb_exp_ctrl is
  constant PERIOD : time := 1 sec / 8192;
  -- constant PERIOD : time := 5 ns;

  component exp_ctrl is
    port (
      clk      : in    std_ulogic;
      reset    : in    std_ulogic;
      timer_go : in    std_ulogic;
      exp_time : in    TDigits;
      expose   : buffer std_ulogic;
      no_pics  : buffer TDigits
    );
  end component exp_ctrl;

  signal w_clk      : std_ulogic := '0';
  signal w_reset    : std_ulogic;
  signal w_timer_go : std_ulogic;
  signal w_exp_time : TDigits;
  signal w_expose   : std_ulogic;
  signal w_no_pics  : TDigits;

begin

  dut : component exp_ctrl
    port map (
      clk      => w_clk,
      reset    => w_reset,
      timer_go => w_timer_go,
      exp_time => w_exp_time,
      expose   => w_expose,
      no_pics  => w_no_pics
    );

  w_clk <= not w_clk after PERIOD / 2;

  stimuli : process is
  begin
    w_reset    <= '1';
    w_timer_go <= '1';
    w_exp_time <= (0, 6, 4);
    wait for 3 * PERIOD;
    assert w_expose = '0';
    assert w_no_pics = (0, 0, 0);

    w_reset    <= '0';
    w_timer_go <= '0';
    wait for 3 * PERIOD;
    -- no changes
    assert w_expose = '0';
    assert w_no_pics = (0, 0, 0);

    w_timer_go <= '1';
    wait for 1 * PERIOD;
    w_timer_go <= '0';
    wait for 1 * PERIOD;
    assert w_expose = '1';
    assert w_no_pics = (0, 0, 1);

    w_timer_go <= '1';
    wait for 1 * PERIOD;
    w_timer_go <= '0';
    wait for 1 * PERIOD;
    w_timer_go <= '1';
    wait for 1 * PERIOD;
    w_timer_go <= '0';

    wait for 1 sec / 64 - 5 * PERIOD;
    assert w_expose = '1';
    assert w_no_pics = (0, 0, 1);
    wait for 1 * PERIOD;
    assert w_expose = '0';
    assert w_no_pics = (0, 0, 1);

    wait for 10 * PERIOD;
    w_exp_time <= (5, 1, 2);

    for i in 1 to 100 loop
      w_timer_go <= '1';
      wait for 1 * PERIOD;
      w_timer_go <= '0';
      wait for 1 sec / 512;
    end loop;
    assert w_no_pics = (1, 0, 1);

    std.env.finish;
  end process stimuli;
end architecture test;

configuration CFG_TB_EXP_CTRL of TB_EXP_CTRL is
  for TEST
  end for;
end CFG_TB_EXP_CTRL;
