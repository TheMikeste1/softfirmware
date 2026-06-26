architecture rtl_if of decoder is
begin

  decode : process (keypad) is
  begin
    if keypad(0) = '1' then
      key <= (0, 0, 1);
    elsif keypad(1) = '1' then
      key <= (0, 0, 2);
    elsif keypad(2) = '1' then
      key <= (0, 0, 4);
    elsif keypad(3) = '1' then
      key <= (0, 0, 8);
    elsif keypad(4) = '1' then
      key <= (0, 1, 6);
    elsif keypad(5) = '1' then
      key <= (0, 3, 2);
    elsif keypad(6) = '1' then
      key <= (0, 6, 4);
    elsif keypad(7) = '1' then
      key <= (1, 2, 8);
    elsif keypad(8) = '1' then
      key <= (2, 5, 6);
    elsif keypad(9) = '1' then
      key <= (5, 1, 2);
    else
      -- Nothing is pressed
      key <= (0, 0, 1);
    end if;
  end process decode;
end architecture rtl_if;
