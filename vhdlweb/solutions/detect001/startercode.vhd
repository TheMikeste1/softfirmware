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
  type   TState is (Invalid, FirstZero, SecondZero, Valid);
  signal r_state      : TState := Invalid;
  signal r_next_state : TState;
begin

  transition : process (r_state, input) is
  begin
    r_next_state <= Invalid;
    case r_state is
      when Invalid =>
        if input = '0' then
          r_next_state <= FirstZero;
        end if;
      when FirstZero =>
        if input = '0' then
          r_next_state <= SecondZero;
        end if;
      when SecondZero =>
        if input = '1' then
          r_next_state <= Valid;
        elsif input = '0' then
          r_next_state <= SecondZero;
        end if;
      when Valid =>
        if input = '0' then
          r_next_state <= FirstZero;
        end if;
    end case;
  end process transition;

  tick : process (clk) is
  begin
    if rising_edge(clk) then
      r_state <= r_next_state;
    end if;
  end process tick;

  result <= '1' when r_state = Valid else
            '0';
end architecture synth;
