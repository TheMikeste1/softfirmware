--  Testbench for 4:1 multiplexer

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use std.textio.all;

entity mux41_test is
-- No ports, since this is a testbench
end entity mux41_test;

architecture test of mux41_test is
  signal w_d : std_ulogic_vector(3 downto 0);
  signal w_s : std_ulogic_vector(1 downto 0);
  signal w_y : std_ulogic;
begin

  dut : entity work.mux41(synth)
    port map (
      d => w_d,
      s => w_s,
      y => w_y
    );

  proc_name : process is
  begin

    for val_s in 0 to (2 ** (w_s'high + 1)) - 1 loop
      w_s <= std_ulogic_vector(to_unsigned(val_s, w_s'length));

      for val_d in 0 to (2 ** (w_d'high + 1)) - 1 loop
        w_d <= std_ulogic_vector(to_unsigned(val_d, w_d'length));

        wait for 10 ns;
        if w_y /= w_d(val_s) then
          report "failed " & to_string(w_s) & ',' & to_string(w_d) & ": " & to_string(w_y);
        end if;
      end loop;
    end loop;

    std.env.finish;
  end process proc_name;

end architecture test;
