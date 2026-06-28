library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity top is
  port (
    leds : out   std_ulogic_vector(1 downto 0)
  );
end entity top;

architecture rtl of top is
  constant COUNT_BIT_LENGTH : integer := 11;

  signal i_clk      : std_logic;
  signal r_count    : unsigned(COUNT_BIT_LENGTH - 1 downto 0) := to_unsigned(0, COUNT_BIT_LENGTH);
  signal r_first_on : std_ulogic                              := '1';

begin

  -- Rude to not have this entity in the instructions.
  osc : entity work.hsosc(sim)
    port map (

      clkhfpu => '1',
      clkhfen => '1',
      clkhf   => i_clk
    );

  tick : process (i_clk) is
  begin
    if rising_edge(i_clk) then
      if r_count = (r_count'range => '1') then
        r_count    <= (others => '0');
        r_first_on <= not r_first_on;
      else
        r_count <= r_count + 1;
      end if;
    end if;
  end process tick;

  leds(0) <= r_first_on;
  leds(1) <= not r_first_on;

end architecture rtl;
