library ieee;
  use std.textio.all;
  use ieee.std_logic_1164.all;
  use work.p_display.all;

entity tb_disp_ctrl is
end entity tb_disp_ctrl;

architecture test of tb_disp_ctrl is
  component disp_ctrl is
    port (
      clk       : in    std_ulogic;
      reset     : in    std_ulogic;
      switch    : in    std_ulogic;
      key       : in    TDigits;
      show_time : out   std_ulogic
    );
  end component disp_ctrl;

  -- vsg_off signal_007
  signal w_clk : std_ulogic := '0';
  -- vsg_on signal_007
  signal w_reset     : std_ulogic;
  signal w_switch    : std_ulogic;
  signal w_key       : TDigits;
  signal w_show_time : std_ulogic;

begin

  -- vsg_off instantiation_034
  dut : component disp_ctrl
    port map (
      clk       => w_clk,
      reset     => w_reset,
      switch    => w_switch,
      key       => w_key,
      show_time => w_show_time
    );
  -- vsg_on instantiation_034

  w_clk <= not w_clk after 10 ns;

  stimuli : process is
  begin
    w_key    <= (0, 0, 0);
    w_switch <= '0';
    w_reset  <= '1';
    wait for 5 ns;
    assert w_show_time = '0';

    w_key <= (1, 0, 0);
    wait for 20 ns;
    -- no changes
    assert w_show_time = '0';

    w_switch <= '1';
    wait for 20 ns;
    -- no changes
    assert w_show_time = '0';

    w_switch <= '0';
    wait for 20 ns;
    -- no changes
    assert w_show_time = '0';

    w_reset <= '0';
    wait for 60 ns;
    assert w_show_time = '1';

    w_switch <= '1';
    wait for 20 ns;
    -- no changes
    assert w_show_time = '1';

    w_switch <= '0';
    wait for 20 ns;
    -- no changes
    assert w_show_time = '1';

    w_key <= (0, 0, 0);
    wait for 20 ns;
    -- no changes
    assert w_show_time = '1';

    w_switch <= '1';
    wait for 60 ns;
    assert w_show_time = '0';

    w_switch <= '0';
    wait for 20 ns;
    -- no changes
    assert w_show_time = '0';

    w_switch <= '1';
    wait for 20 ns;
    assert w_show_time = '1';

    w_switch <= '0';
    wait for 20 ns;
    -- no changes
    assert w_show_time = '1';

    std.env.finish;
  end process stimuli;

  sample : process (w_show_time) is
    constant SPACE     : string := " ";
    variable file_line : line;
    file     out_file  : TEXT open write_mode is "lab_6.trace";
  begin
    write(file_line, to_bit(w_show_time));
    writeline(OUT_FILE, file_line);
  end process sample;
end architecture test;

configuration CFG_TB_DISP_CTRL of TB_DISP_CTRL is
  for TEST
  end for;
end CFG_TB_DISP_CTRL;
