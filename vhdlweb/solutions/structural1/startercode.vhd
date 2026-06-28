library ieee;
  use ieee.std_logic_1164.all;

entity funinabox is
  port (
    a      : in    std_logic;
    b      : in    std_logic;
    result : out   std_logic_vector(3 downto 0)
  );
end entity funinabox;

architecture synth of funinabox is
  signal w_ye : std_ulogic_vector(3 downto 0);
begin

  thing1 : entity work.thing1(synth)
    port map (
      s => a,
      t => b,
      y => w_ye
    );

  thing2 : entity work.thing2(synth)
    port map (
      f => a,
      e => w_ye,
      g => result
    );
end architecture synth;
