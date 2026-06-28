library ieee;
  use ieee.std_logic_1164.all;

entity sevenseg01 is
  port (
    s        : in    std_logic;
    segments : out   std_logic_vector(6 downto 0)
  );
end entity sevenseg01;

architecture synth of sevenseg01 is
begin
  --     a
  --    ###
  --   #   #
  -- f #   # b
  --   #   #
  --    ###
  --   # g #
  -- e #   # c
  --   #   #
  --    ###
  --     d
  -- segments "abcdefg"
  segments <= "1111110" when s = '0' else
              "0110000" when s = '1' else
              (others => '0');
end architecture synth;
