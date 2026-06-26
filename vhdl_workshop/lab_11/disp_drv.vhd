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
      w_disp_photo <= no_pics;
    else
      -- output = exposure time
      w_disp_photo <= exp_time;
    end if;
  end process disp_mux;

  decode : process (w_disp_photo) is
  begin
    -- Process all elements of the data arrays
    for i in w_disp_photo'range loop
      case w_disp_photo(i) is
        when 0 => display(i) <= SEG_0;
        when 1 => display(i) <= SEG_1;
        when 2 => display(i) <= SEG_2;
        when 3 => display(i) <= SEG_3;
        when 4 => display(i) <= SEG_4;
        when 5 => display(i) <= SEG_5;
        when 6 => display(i) <= SEG_6;
        when 7 => display(i) <= SEG_7;
        when 8 => display(i) <= SEG_8;
        when 9 => display(i) <= SEG_9;
        when others => display(i) <= SEG_E;
      end case;
    end loop;
  end process decode;
end architecture rtl;
