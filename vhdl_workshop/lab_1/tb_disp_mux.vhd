library ieee;
  use ieee.std_logic_1164.all;

entity tb_disp_mux is
end entity tb_disp_mux;

architecture test of tb_disp_mux is

  component disp_mux is
    port (
      exp_time   : in    integer;
      num_pics   : in    integer;
      show_time  : in    std_ulogic;
      disp_photo : out   integer
    );
  end component disp_mux;

  -- vsg_off signal_007
  signal w_exp_time   : integer    := 0;
  signal w_num_pics   : integer    := 0;
  signal w_show_time  : std_ulogic := '0';
  signal w_disp_photo : integer;
-- vsg_on signal_007

begin

  -- vsg_off instantiation_034
  dut : component disp_mux
    port map (
      exp_time   => w_exp_time,
      num_pics   => w_num_pics,
      show_time  => w_show_time,
      disp_photo => w_disp_photo
    );

  -- vsg_on instantiation_034

  stimuli : process is
  begin

    wait for 30 ns;
    assert w_disp_photo = 0;

    w_num_pics <= 2;
    w_exp_time <= 64;
    wait for 20 ns;
    assert w_disp_photo = 2;

    w_num_pics <= 10;
    wait for 20 ns;
    assert w_disp_photo = 10;

    w_show_time <= '1';
    wait for 20 ns;
    assert w_disp_photo = 64;

    w_num_pics <= 20;
    wait for 20 ns;
    assert w_disp_photo = 64;

    w_show_time <= '0';
    wait for 20 ns;
    assert w_disp_photo = 20;

    wait;

  end process stimuli;

end architecture test;

configuration cfg_tb_disp_mux of tb_disp_mux is
  for test
  end for;
end cfg_tb_disp_mux;
