library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity bitrender is
  port (
    clk   : in    std_logic;
    row   : in    unsigned(2 downto 0); -- vertical position, 0 to 7, in bits
    col   : in    unsigned(5 downto 0); -- horizontal position, 0 to 63, in bits
    pixel : out   std_logic
  );
end entity bitrender;

architecture synth of bitrender is

  signal r_addr : std_logic_vector(5 downto 0);
  signal r_data : std_logic_vector(7 downto 0); -- Memory has 8-bit words

begin

  rom : entity work.rom(sim)
    port map (
      clk  => clk,
      addr => r_addr,
      data => r_data
    );

  r_addr <= std_logic_vector(row)
            & std_logic_vector(col(5 downto 3)); -- 3 bits: byte indices 0 - 7
  pixel  <= r_data(7 -                           -- Subtract from 7 because the left most bit is bit 7
                   to_integer(col(2 downto 0))); -- 3 bits: bit indices 0 - 7.
end architecture synth;
