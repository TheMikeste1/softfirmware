library ieee;
  use ieee.std_logic_1164.all;

entity detect001 is
  port (
    clk    : in    std_logic;
    input  : in    std_logic;
    result : out   std_logic
  );
end entity detect001;

architecture synth of detect001 is
  type   TState is (One, Two, Three, High);
  signal r_state : TState := One;
begin

  tick : process (clk) is
  begin
    if rising_edge(clk) then
      case r_state is
        when One =>
          if input = '0' then
            r_state <= Two;
          end if;
        when Two =>
          if input = '0' then
            r_state <= Three;
          end if;
        when Three =>
          if input = '1' then
            r_state <= High;
          end if;
        when High =>
          if input = '0' then
            r_state <= Two;
          else
            r_state <= One;
          end if;
      end case;
    end if;
  end process tick;

  result <= '1' when r_state = High else
            '0';
end architecture synth;
