library ieee;
  use ieee.std_logic_1164.all;

entity tb_disp_mux is
end entity tb_disp_mux;

architecture test of tb_disp_mux is

  component disp_mux is
    port (
      exp_time   : in    integer range 0 to 10;
      num_pics   : in    integer range 0 to 10;
      show_time  : in    std_ulogic;
      i_error    : in    std_ulogic;
      disp_photo : out   integer range 0 to 10
    );
  end component disp_mux;

  -- vsg_off signal_007
  signal w_exp_time   : integer range 0 to 10 := 0;
  signal w_num_pics   : integer range 0 to 10 := 0;
  signal w_show_time  : std_ulogic            := '0';
  signal w_error      : std_ulogic            := '0';
  signal w_disp_photo : integer range 0 to 10;

-- vsg_on signal_007

begin

  -- vsg_off instantiation_034
  dut : component disp_mux
    port map (
      exp_time   => w_exp_time,
      num_pics   => w_num_pics,
      show_time  => w_show_time,
      i_error    => w_error,
      disp_photo => w_disp_photo
    );

  -- vsg_on instantiation_034

  stimuli : process is
  begin

    wait for 30 ns;
    assert w_disp_photo = 0;

    w_num_pics <= 2;
    w_exp_time <= 5;
    wait for 20 ns;
    assert w_disp_photo = 2;

    w_num_pics <= 10;
    wait for 20 ns;
    assert w_disp_photo = 10;

    w_show_time <= '1';
    wait for 20 ns;
    assert w_disp_photo = 5;

    w_exp_time <= 6;
    w_num_pics <= 4;
    wait for 20 ns;
    assert w_disp_photo = 6;

    w_show_time <= '0';
    wait for 20 ns;
    assert w_disp_photo = 4;

    w_error <= '1';
    wait for 20 ns;
    assert w_disp_photo = 10;

    w_show_time <= '1';
    wait for 20 ns;
    assert w_disp_photo = 10;

    w_error <= '0';
    wait for 20 ns;
    assert w_disp_photo = 6;

    w_show_time <= '0';
    wait for 20 ns;
    assert w_disp_photo = 4;
    wait;

  end process stimuli;

end architecture test;

configuration cfg_tb_disp_mux of tb_disp_mux is
  for test
  end for;
end cfg_tb_disp_mux;
