library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity countto is
  port (
    clk   : in    std_logic;
    reset : in    std_logic;
    count : out   unsigned(3 downto 0)
  );
end entity countto;

architecture synth of countto is
begin

  tick : process (clk) is
  begin
    if rising_edge(clk) then
      if reset = '1' then
        count <= 4d"0";
      else
        count <= count + 1;
        if count >= 9 then
          count <= 4d"0";
        end if;
      end if;
    end if;
  end process tick;
end architecture synth;
