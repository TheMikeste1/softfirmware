--  Testbench for 4-bit adder

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use std.textio.all;

entity adder_test is
-- No ports, since this is a testbench
end entity adder_test;

architecture test of adder_test is
  signal w_a   : unsigned(3 downto 0);
  signal w_b   : unsigned(3 downto 0);
  signal w_sum : unsigned(3 downto 0);
begin

  dut : entity work.adder(synth)
    port map (
      a   => w_a,
      b   => w_b,
      sum => w_sum
    );

  proc_name : process is
  begin

    for val_a in 0 to 2 ** (w_a'high + 1) - 1 loop
      w_a <= to_unsigned(val_a, w_a'length);

      for val_b in 0 to 2 ** (w_b'high + 1) - 1 loop
        w_b <= to_unsigned(val_b, w_b'length);

        wait for 10 ns;
        if w_sum /= w_a + w_b then
          report "failed";
        end if;
      end loop;
    end loop;

    std.env.finish;
  end process proc_name;

end architecture test;
