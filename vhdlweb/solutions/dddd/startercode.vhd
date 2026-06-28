library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity dddd is
  port (
    value     : in    unsigned(5 downto 0);
    tensdigit : out   std_logic_vector(6 downto 0);
    onesdigit : out   std_logic_vector(6 downto 0)
  );
end entity dddd;

architecture sim of dddd is

  signal s_ones : unsigned(3 downto 0);
  signal s_tens : unsigned(3 downto 0);
begin

  ones : entity work.sevenseg(synth)
    port map (
      s        => s_ones,
      segments => onesdigit
    );

  tens : entity work.sevenseg(synth)
    port map (
      s        => s_tens,
      segments => tensdigit
    );

  s_ones <= value mod 4d"10";
  s_tens <= resize(value / 10, 4);

end architecture sim;
