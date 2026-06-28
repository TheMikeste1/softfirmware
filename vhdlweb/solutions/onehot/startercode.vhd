library ieee;
  use ieee.std_logic_1164.all;

entity onehot is
  port (
    clk   : in    std_logic;
    reset : in    std_logic;
    count : out   std_logic_vector(7 downto 0)
  );
end entity onehot;

architecture synth of onehot is
begin

  tick : process (clk) is
  begin
    if rising_edge(clk) then
      if reset = '1' then
        count <= "00000001";
      else

        for i in 7 downto 1 loop
          count(i) <= count(i - 1);
        end loop;
        count(0) <= count (7);
      end if;
    end if;
  end process tick;
end architecture synth;
