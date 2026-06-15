library ieee;
  use ieee.std_logic_1164.all;

entity disp_mux is
  port (
    exp_time   : in    integer range 0 to 10; -- range needed
    num_pics   : in    integer range 0 to 10; -- range needed
    show_time  : in    std_ulogic;
    i_error    : in    std_ulogic;
    disp_photo : out   integer range 0 to 10  -- range needed
  );
end entity disp_mux;

architecture rtl of disp_mux is

begin

  mux : process (num_pics, exp_time, show_time, i_error) is -- complete sensitivity list!!
  begin

    -- add ERROR condition
    if (i_error = '1') then
      disp_photo <= 10;
    elsif (show_time = '1') then
      disp_photo <= exp_time;
    else
      disp_photo <= num_pics;
    end if;

  end process mux;

end architecture rtl;

