library ieee;
  use ieee.std_logic_1164.all;

entity lfsr4 is
  port (
    clk   : in    std_logic;
    reset : in    std_logic;
    count : out   std_logic_vector(3 downto 0)
  );
end entity lfsr4;

architecture synth of lfsr4 is
  signal r_count : std_ulogic_vector(count'range);
begin

  tick : process (clk) is
  begin
    if rising_edge(clk) then
      if reset = '1' then
        r_count <= "0001";
      else
        r_count(0) <= r_count(1);
        r_count(1) <= r_count(2);
        r_count(2) <= r_count(0) xor r_count(3);
        r_count(3) <= r_count(0);
      end if;
    end if;
  end process tick;

  count <= r_count;
end architecture synth;
