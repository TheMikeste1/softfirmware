library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity counter_enable is
  port (
    clk    : in    std_logic;
    reset  : in    std_logic;
    enable : in    std_logic;
    count  : out   unsigned(2 downto 0)
  );
end entity counter_enable;

architecture synth of counter_enable is
begin

  tick : process (clk) is
  begin
    if rising_edge(clk) then
      if reset = '1' then
        count <= "000";
      else
        if enable = '1' then
          count <= count + 1;
        end if;
      end if;
    end if;
  end process tick;
end architecture synth;
