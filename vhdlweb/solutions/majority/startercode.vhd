library ieee;
  use ieee.std_logic_1164.all;

entity majority is
  port (
    votes : in    std_logic_vector(2 downto 0);
    y     : out   std_logic
  );
end entity majority;

architecture synth of majority is
begin

  vote : process (votes) is
    variable sum : natural range 0 to 3;
  begin
    sum := 0;
    y   <= '0';

    for i in votes'range loop
      if votes(i) = '1' then
        sum := sum + 1;
      end if;
    end loop;

    if sum > votes'length / 2 then
      y <= '1';
    end if;
  end process vote;
end architecture synth;
