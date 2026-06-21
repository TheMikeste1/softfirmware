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
  signal w_disp_photo : TDigits;
begin

  disp_mux : process (show_time, i_error,
                      exp_time, no_pics) is
  begin
    if i_error = '1' then
      w_disp_photo <= (10, 10, 10);
    elsif show_time = '0' then
    -- output = picture count
    else
    -- output = exposure time
    end if;
  end process disp_mux;

  decode : process (w_disp_photo) is
  begin
    -- Process all elements of the data arrays
    case w_disp_photo is
      when 0 => display <= SEG_0;
      when 1 => display <= SEG_1;
      when 2 => display <= SEG_2;
      when 3 => display <= SEG_3;
      when 4 => display <= SEG_4;
      when 5 => display <= SEG_5;
      when 6 => display <= SEG_6;
      when 7 => display <= SEG_7;
      when 8 => display <= SEG_8;
      when 9 => display <= SEG_9;
      when others => display <= SEG_E;
    end case;
  end process decode;
end architecture rtl;
