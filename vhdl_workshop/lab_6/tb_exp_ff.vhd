library ieee;
  use std.textio.all;
  use ieee.std_logic_1164.all;
  use work.p_display.all;

entity tb_exp_ff is
end entity tb_exp_ff;

architecture test of tb_exp_ff is
  component exp_ff is
    port (
      clk      : in    std_ulogic;
      reset    : in    std_ulogic;
      key      : in    TDigits;
      exp_time : out   TDigits
    );
  end component exp_ff;

  -- vsg_off signal_007
  signal w_clk : std_ulogic := '0';
  -- vsg_on signal_007
  signal w_reset    : std_ulogic;
  signal w_key      : TDigits;
  signal w_exp_time : TDigits;

begin

  -- vsg_off instantiation_034
  dut : component exp_ff
    port map (
      clk      => w_clk,
      reset    => w_reset,
      key      => w_key,
      exp_time => w_exp_time
    );
  -- vsg_on instantiation_034

  w_clk <= not w_clk after 10 ns;

  stimuli : process is
  begin
    w_key   <= (0, 0, 0);
    w_reset <= '1';
    wait for 5 ns;
    report "CLK: " & to_string(w_clk) & " (" & to_string(now) & ")";
    assert w_exp_time = (0, 0, 1);

    w_reset <= '0';
    wait for 15 ns;
    -- no changes (all 0 shall be ignored)
    report "CLK: " & to_string(w_clk) & " (" & to_string(now) & ")";
    assert w_exp_time = (0, 0, 1);

    w_key <= (1, 2, 3);
    wait for 5 ns;
    -- no changes (no active clock edge)
    report "CLK: " & to_string(w_clk) & " (" & to_string(now) & ")";
    assert w_exp_time = (0, 0, 1);

    w_key <= (2, 2, 3);
    wait for 15 ns;
    report "CLK: " & to_string(w_clk) & " (" & to_string(now) & ")";
    assert w_exp_time = (2, 2, 3);

    w_key <= (0, 3, 5);
    wait for 15 ns;
    assert w_exp_time = (0, 3, 5);
    wait for 10 ns;

    std.env.finish;
  end process stimuli;

  sample : process (w_exp_time) is
    constant SPACE     : string := " ";
    variable file_line : line;

    file out_file : TEXT open write_mode is "lab_6.trace";
  begin
    write(file_line, w_exp_time(2));
    write(file_line, SPACE);
    write(file_line, w_exp_time(1));
    write(file_line, SPACE);
    write(file_line, w_exp_time(0));

    writeline(out_file, file_line);
  end process sample;
end architecture test;

configuration CFG_TB_EXP_FF of TB_EXP_FF is
  for TEST
  end for;
end CFG_TB_EXP_FF;
