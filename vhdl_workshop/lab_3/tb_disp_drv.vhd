-- vsg_off signal_007

library ieee;
  use ieee.std_logic_1164.all;
  use work.p_display.all;

entity tb_disp_drv is
end entity tb_disp_drv;

architecture test of tb_disp_drv is
  component disp_drv is
    port (
      i_error   : in    std_ulogic;
      show_time : in    std_ulogic;
      no_pics   : in    TDigits;
      exp_time  : in    TDigits;
      display   : out   TDisplay
    );
  end component disp_drv;

  signal w_error     : std_ulogic := '0';
  signal w_show_time : std_ulogic := '0';
  signal w_no_pics   : TDigits;
  signal w_exp_time  : TDigits;
  signal w_display   : TDisplay;

begin
  -- vsg_off instantiation_034
  dut : component disp_drv
    port map (
      i_error   => w_error,
      no_pics   => w_no_pics,
      exp_time  => w_exp_time,
      show_time => w_show_time,
      display   => w_display
    );
  -- vsg_on instantiation_034

  stimuli : process is
  begin

    wait for 30 ns;
    -- report "1: " & to_string(w_display);
    assert w_display = c_SEG_0;

    w_no_pics  <= 0;
    w_exp_time <= 5;
    wait for 20 ns;
    -- no changes
    assert w_display = c_SEG_0;

    for i in 1 to 10 loop
      w_no_pics <= i;
      wait for 20 ns;
      -- DISPLAY = 1..E (03,6D,67,53,76,7E,23,7F,77,7C)
      case i is
        when 1 =>
          assert w_display = c_SEG_1;
        when 2 =>
          assert w_display = c_SEG_2;
        when 3 =>
          assert w_display = c_SEG_3;
        when 4 =>
          assert w_display = c_SEG_4;
        when 5 =>
          assert w_display = c_SEG_5;
        when 6 =>
          assert w_display = c_SEG_6;
        when 7 =>
          assert w_display = c_SEG_7;
        when 8 =>
          assert w_display = c_SEG_8;
        when 9 =>
          assert w_display = c_SEG_9;
        when others =>
          assert w_display = c_SEG_E;
      end case;
    end loop;

    w_show_time <= '1';
    wait for 20 ns;
    assert w_display = c_SEG_5;

    w_exp_time <= 6;
    w_no_pics  <= 4;
    wait for 20 ns;
    assert w_display = c_SEG_6;

    w_show_time <= '0';
    wait for 20 ns;
    assert w_display = c_SEG_4;

    w_error <= '1';
    wait for 20 ns;
    assert w_display = c_SEG_E;

    w_show_time <= '1';
    wait for 20 ns;
    -- no changes
    assert w_display = c_SEG_E;

    w_error <= '0';
    wait for 20 ns;
    assert w_display = c_SEG_6;

    w_show_time <= '0';
    wait for 20 ns;
    assert w_display = c_SEG_4;
    wait;
  end process stimuli;

  display_digit(w_display);

end architecture test;

configuration CFG_TB_DISP_DRV of TB_DISP_DRV is
  for TEST
  end for;
end CFG_TB_DISP_DRV;
