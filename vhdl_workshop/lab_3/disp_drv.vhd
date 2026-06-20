library ieee;
  use ieee.std_logic_1164.all;
  use work.p_display.all;

entity disp_drv is
  port (
    i_error   : in    std_ulogic;
    show_time : in    std_ulogic;
    no_pics   : in    TDigits;
    exp_time  : in    TDigits;
    display   : out   TDisplay
  );
end entity disp_drv;

architecture rtl of disp_drv is

  -- intermediate signals
  signal w_disp_photo : TDigits;

begin

  disp_mux : process (no_pics, exp_time, show_time, i_error) is
  -- complete sensitivity list!!
  begin

    -- add ERROR condition
    if (i_error = '1') then
      w_disp_photo <= 10;
    elsif (show_time = '1') then
      -- output = exposure time
      w_disp_photo <= exp_time;
    else
      -- output = picture count
      w_disp_photo <= no_pics;
    end if;

  end process disp_mux;

  decoder : process (w_disp_photo) is
  begin
    case w_disp_photo is
      when 0 =>
        display <= c_SEG_0;
      when 1 =>
        display <= c_SEG_1;
      when 2 =>
        display <= c_SEG_2;
      when 3 =>
        display <= c_SEG_3;
      when 4 =>
        display <= c_SEG_4;
      when 5 =>
        display <= c_SEG_5;
      when 6 =>
        display <= c_SEG_6;
      when 7 =>
        display <= c_SEG_7;
      when 8 =>
        display <= c_SEG_8;
      when 9 =>
        display <= c_SEG_9;
      when others =>
        display <= c_SEG_E;
    end case;
  end process decoder;

end architecture rtl;

