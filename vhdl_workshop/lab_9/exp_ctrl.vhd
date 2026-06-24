library ieee;
  use ieee.std_logic_1164.all;
  use work.p_display.all;

entity exp_ctrl is
  port (
    clk      : in    std_ulogic;
    reset    : in    std_ulogic;
    timer_go : in    std_ulogic;
    exp_time : in    TDigits;
    expose   : out   std_ulogic;
    no_pics  : out   TDigits
  );
end entity exp_ctrl;

architecture rtl of exp_ctrl is
  -- The EXP_TIME signal must be mapped to a limit for the
  -- exposure timer, i.e. an internal signal is needed

  signal w_limit : integer range 0 to 511;

  procedure inc_digit (
    digit : inout integer;
    carry : inout std_ulogic
  ) is
  begin
    if carry = '1' then
      if digit /= 9 then
        digit := digit + 1;
        carry := '0';
      else
        digit := 0;
      end if; -- OVERFLOW
    end if;   -- CARRY = '1'
  end procedure inc_digit;

begin -- architecture

  mapper : process (exp_time) is
  begin
    -- default assignment for all outputs to avoid latches
    if exp_time = (5, 1, 2) then
      w_limit <= 0;
    elsif exp_time = (2, 5, 6) then
      w_limit <= 1;
    elsif exp_time = (1, 2, 8) then
      w_limit <= 512 / 128 - 1;
    elsif exp_time = (0, 6, 4) then
      w_limit <= 512 / 64 - 1;
    elsif exp_time = (0, 3, 2) then
      w_limit <= 512 / 32 - 1;
    elsif exp_time = (0, 1, 6) then
      w_limit <= 512 / 16 - 1;
    elsif exp_time = (0, 0, 8) then
      w_limit <= 512 / 8 - 1;
    elsif exp_time = (0, 0, 4) then
      w_limit <= 512 / 4 - 1;
    elsif exp_time = (0, 0, 2) then
      w_limit <= 512 / 2 - 1;
    elsif exp_time = (0, 0, 1) then
      w_limit <= 512 / 1 - 1;
    else
      w_limit <= 0;
    end if;
  end process mapper;

  exp_timer : process (clk, reset) is
    variable count_16 : integer range 0 to 16;  -- Counter to generate 1/512s timesteps
    variable timer    : integer range 0 to 256; -- Counter for the final exposure time
  begin
    if reset = '1' then
      count_16 := 0;
      timer    := 0;
      expose   <= '0';
    -- Reset all registers
    elsif (clk'event and clk = '1') then
      if expose = '1' then
        -- Exposure timer
        -- 2 cascaded counters: 1st -> 1/512s timesteps
        count_16 := count_16 + 1;
        -- 2nd -> exposure time
        if count_16 >= 16 then
          timer    := timer + 1;
          count_16 := 0;
        end if;

        if timer > w_limit then
          expose <= '0';
        end if;
      elsif timer_go = '1' then
        -- Start exposure timer
        count_16 := 0;
        timer    := 0;
        expose   <= '1';
      end if;
    end if;
  end process exp_timer;

  pic_count : process (clk, reset) is
    variable last_expose : std_ulogic;
    variable carry       : std_ulogic;
    variable digit       : integer;
  begin
    if reset = '1' then
      last_expose := '0';
      no_pics     <= (0, 0, 0);
    elsif clk'event and clk = '1' then
      if last_expose = '0' and expose = '1' then
        carry := '1';

        for i in TDigits'low to TDigits'high loop
          -- Increment the picture counter
          digit      := no_pics(i);
          inc_digit(digit, carry);
          no_pics(i) <= digit;
        end loop;
      end if;

      last_expose := expose;
    end if; -- Rising clock edge
  end process pic_count;
end architecture rtl;
