library ieee;
  use ieee.std_logic_1164.all;

entity lfsr2 is
  port (
    clk   : in    std_logic;
    reset : in    std_logic;
    b     : out   std_logic
  );
end entity lfsr2;

architecture synth of lfsr2 is
  signal r_prev_was_high : std_ulogic_vector(1 downto 0);
begin
  -- Q: How do you eat a digital elephant?
  -- A: One byte at a time.
  tick : process (clk) is
  begin
    if rising_edge(clk) then
      if reset = '1' then
        r_prev_was_high <= "11";
      else
        r_prev_was_high(0) <= r_prev_was_high(1);
        r_prev_was_high(1) <= xor(r_prev_was_high);
      end if;
    end if;
  end process tick;

  b <= r_prev_was_high(0);
end architecture synth;
