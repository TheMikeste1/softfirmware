library ieee;
  use ieee.std_logic_1164.all;

entity adderlogic is
  port (
    a   : in    std_logic_vector(2 downto 0);
    b   : in    std_logic_vector(2 downto 0);
    sum : out   std_logic_vector(3 downto 0)
  );
end entity adderlogic;

architecture synth of adderlogic is
  signal r_overflow : std_ulogic_vector(3 downto 0);
begin

  r_overflow(0) <= '0';

  summation : for i in a'range generate
    sum(i)            <= a(i) xor b(i) xor r_overflow(i);
    r_overflow(i + 1) <= (a(i) and b(i))
                         or (a(i) and r_overflow(i))
                         or (b(i) and r_overflow(i));
  end generate summation;

  sum(3) <= r_overflow(3);
end architecture synth;

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all; -- Required for unsigned math operators

architecture alternative of adderlogic is
  signal w_a_padded : unsigned(3 downto 0);
  signal w_b_padded : unsigned(3 downto 0);
  signal w_sum_res  : unsigned(3 downto 0);
begin

  -- 1. Pad inputs with a leading zero to prevent overflow truncation
  w_a_padded <= unsigned('0' & a);
  w_b_padded <= unsigned('0' & b);

  -- 2. Perform the addition using the '+' operator
  w_sum_res <= w_a_padded + w_b_padded;

  -- 3. Cast the result back to std_logic_vector for the output port
  sum <= std_logic_vector(w_sum_res);

end architecture alternative;

