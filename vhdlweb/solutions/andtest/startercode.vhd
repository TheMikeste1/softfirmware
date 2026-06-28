--  Testbench for AND gate

library ieee;
  use ieee.std_logic_1164.all;
  use std.textio.all;

entity and_test is
-- No ports, since this is a testbench
end entity and_test;

architecture test of and_test is

  component andgate is
    port (
      a : in    std_logic;
      b : in    std_logic;
      y : out   std_logic
    );
  end component andgate;

  signal w_a : std_ulogic;
  signal w_b : std_ulogic;
  signal w_y : std_ulogic;
begin

  dut : entity work.andgate(synth)
    port map (
      a => w_a,
      b => w_b,
      y => w_y
    );

  proc_name : process is
  begin

    w_a <= '0';
    w_b <= '0';
    wait for 10 ns;
    if w_y = '1' then
      report "failed " & to_string(w_a) & "," & to_string(w_b) & ": " & to_string(w_y);
    end if;

    w_a <= '1';
    w_b <= '0';
    wait for 10 ns;
    if w_y = '1' then
      report "failed " & to_string(w_a) & "," & to_string(w_b) & ": " & to_string(w_y);
    end if;

    w_a <= '0';
    w_b <= '1';
    wait for 10 ns;
    if w_y = '1' then
      report "failed " & to_string(w_a) & "," & to_string(w_b) & ": " & to_string(w_y);
    end if;

    w_a <= '1';
    w_b <= '1';
    wait for 10 ns;
    if w_y = '0' then
      report "failed " & to_string(w_a) & "," & to_string(w_b) & ": " & to_string(w_y);
    end if;

    std.env.finish;
  end process proc_name;

end architecture test;
