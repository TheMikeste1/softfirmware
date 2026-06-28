library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity sevenseg is
  port (
    s        : in    unsigned(3 downto 0);
    segments : out   std_logic_vector(6 downto 0)
  );
end entity sevenseg;

architecture synth of sevenseg is
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
  segments <= "0000001" when s = "0000" else
              "1001111" when s = "0001" else -- 1
              "0010010" when s = "0010" else -- 2
              "0000110" when s = "0011" else -- 3
              "1001100" when s = "0100" else -- 4
              "0100100" when s = "0101" else -- 5
              "0100000" when s = "0110" else -- 6
              "0001111" when s = "0111" else -- 7
              "0000000" when s = "1000" else -- 8
              "0000100" when s = "1001" else -- 9
              "1000111";                     -- The test arbitrarily draws a backwards L when there's an error
end architecture synth;
