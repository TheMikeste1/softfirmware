library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity decrementmem is
  port (
    clk : in    std_logic;
    run : in    std_logic; -- When this is asserted, begin one pass through the memory

    -- Signals below are connected to the RAM inside the testbench
    addr        : out   unsigned(3 downto 0);         -- The address to read/write
    dataread    : in    std_logic_vector(7 downto 0); -- The data read
    datawrite   : out   std_logic_vector(7 downto 0); -- The data write
    writeenable : out   std_logic                     -- If data should be written to addr.
  );
end entity decrementmem;

architecture synth of decrementmem is

  constant ADDR_WIDTH : natural := 4;
  constant RAM_DEPTH  : natural := 2 ** ADDR_WIDTH;

  type   State is (Idle, Read, Write);
  signal r_prev_state : State                := Idle;
  signal r_state      : State;
  signal nextaddr     : unsigned(addr'range) := 4d"0";

begin

  transition : process (r_prev_state, run) is
  begin
    r_state <= r_prev_state;
    case r_prev_state is
      when Idle =>
        if run then
          r_state <= Read;
        else
          r_state <= Idle;
        end if;
      when Read =>
        r_state <= Write;
      when Write =>
        if nextaddr = RAM_DEPTH - 1 then
          nextaddr <= 4d"0";
          r_state  <= Idle;
        else
          nextaddr <= nextaddr + 1;
          r_state  <= Read;
        end if;
    end case;
  end process transition;

  tick : process (clk) is
  begin
    if rising_edge(clk) then
      r_prev_state <= r_state;
    end if;
  end process tick;

  datawrite   <= std_logic_vector(unsigned(dataread) - 1);
  addr        <= nextaddr;
  writeenable <= '1' when r_state = Write else
                 '0';
end architecture synth;
