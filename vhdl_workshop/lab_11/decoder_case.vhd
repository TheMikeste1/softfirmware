architecture rtl_case of decoder is
begin

  decode : process (keypad) is
  begin
    case keypad is
      when "1000000000" => key <= (5, 1, 2);
      when "0100000000" => key <= (2, 5, 6);
      when "0010000000" => key <= (1, 2, 8);
      when "0001000000" => key <= (0, 6, 4);
      when "0000100000" => key <= (0, 3, 2);
      when "0000010000" => key <= (0, 1, 6);
      when "0000001000" => key <= (0, 0, 8);
      when "0000000100" => key <= (0, 0, 4);
      when "0000000010" => key <= (0, 0, 2);
      when "0000000001" => key <= (0, 0, 1);
      when others => key <= (0, 0, 0);
    end case;
  end process decode;
end architecture rtl_case;
