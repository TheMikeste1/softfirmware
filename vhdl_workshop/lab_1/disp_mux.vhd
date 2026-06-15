library ieee;
  use ieee.std_logic_1164.all;

entity disp_mux is
  port (
    exp_time   : in    integer;
    num_pics   : in    integer;
    show_time  : in    std_ulogic;
    disp_photo : out   integer
  );
end entity disp_mux;

architecture rtl of disp_mux is

begin

  mux : process (num_pics, exp_time, show_time) is
  begin

    disp_photo <= 0;

    if (show_time = '1') then
      disp_photo <= exp_time;
    else
      disp_photo <= num_pics;
    end if;

  end process mux;

end architecture rtl;

