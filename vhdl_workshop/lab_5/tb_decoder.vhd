library ieee;
  use ieee.std_logic_1164.all;
  use work.p_display.all;

entity tb_decoder is
end entity tb_decoder;

architecture test of tb_decoder is
  signal w_keypad_if   : std_ulogic_vector (9 downto 0);
  signal w_key_if      : TDigits;
  signal w_keypad_case : std_ulogic_vector (9 downto 0);
  signal w_key_case    : TDigits;
begin

  dut_if : entity work.decoder(RTL_IF)
    port map (
      keypad => w_keypad_if,
      key    => w_key_if
    );

  dut_case : entity work.decoder(RTL_CASE)
    port map (
      keypad => w_keypad_case,
      key    => w_key_case
    );

  stimuli_if : process is
  begin
    w_keypad_if <= "1000000000";
    wait for 20 ns;
    assert w_key_if = (5, 1, 2);                    -- both

    w_keypad_if <= "1111100000";
    wait for 20 ns;
    assert w_key_if = (0, 3, 2);                    -- if

    w_keypad_if <= "0000100000";
    wait for 20 ns;
    assert w_key_if = (0, 3, 2);                    -- both

    for i in 9 downto 0 loop
      w_keypad_if    <= (others => '0');
      w_keypad_if(I) <= '1';

      wait for 20 ns;
      -- both
      -- KEY = (5,1,2),(2,5,6),(1,2,8),(0,6,4),(0,3,2),
      --       (0,1,6),(0,0,8),(0,0,4),(0,0,2),(0,0,1)
      case i is
        when 1 => assert w_key_if = (0, 0, 2)
            report "i=" & to_string(i);
        when 2 => assert w_key_if = (0, 0, 4)
            report "i=" & to_string(i);
        when 3 => assert w_key_if = (0, 0, 8)
            report "i=" & to_string(i);
        when 4 => assert w_key_if = (0, 1, 6)
            report "i=" & to_string(i);
        when 5 => assert w_key_if = (0, 3, 2)
            report "i=" & to_string(i);
        when 6 => assert w_key_if = (0, 6, 4)
            report "i=" & to_string(i);
        when 7 => assert w_key_if = (1, 2, 8)
            report "i=" & to_string(i);
        when 8 => assert w_key_if = (2, 5, 6)
            report "i=" & to_string(i);
        when 9 => assert w_key_if = (5, 1, 2)
            report "i=" & to_string(i);
        when 0 => assert w_key_if = (0, 0, 1)
            report "i=" & to_string(i);
        when others => assert w_key_if = (0, 0, 1)
            report "i=" & to_string(i);
      end case;
    end loop;
    wait;
  end process stimuli_if;

  stimuli_case : process is
  begin
    w_keypad_case <= "1000000000";
    wait for 20 ns;
    assert w_key_case = (5, 1, 2);                    -- both

    w_keypad_case <= "1111100000";
    wait for 20 ns;
    assert w_key_case = (0, 0, 0);                    -- case

    w_keypad_case <= "0000100000";
    wait for 20 ns;
    assert w_key_case = (0, 3, 2);                    -- both

    for i in 9 downto 0 loop
      w_keypad_case    <= (others => '0');
      w_keypad_case(I) <= '1';

      wait for 20 ns;
      -- both
      -- KEY = (5,1,2),(2,5,6),(1,2,8),(0,6,4),(0,3,2),
      --       (0,1,6),(0,0,8),(0,0,4),(0,0,2),(0,0,1)
      case i is
        when 1 => assert w_key_if = (0, 0, 2)
            report "i=" & to_string(i);
        when 2 => assert w_key_if = (0, 0, 4)
            report "i=" & to_string(i);
        when 3 => assert w_key_if = (0, 0, 8)
            report "i=" & to_string(i);
        when 4 => assert w_key_if = (0, 1, 6)
            report "i=" & to_string(i);
        when 5 => assert w_key_if = (0, 3, 2)
            report "i=" & to_string(i);
        when 6 => assert w_key_if = (0, 6, 4)
            report "i=" & to_string(i);
        when 7 => assert w_key_if = (1, 2, 8)
            report "i=" & to_string(i);
        when 8 => assert w_key_if = (2, 5, 6)
            report "i=" & to_string(i);
        when 9 => assert w_key_if = (5, 1, 2)
            report "i=" & to_string(i);
        when 0 => assert w_key_if = (0, 0, 1)
            report "i=" & to_string(i);
        when others => assert w_key_case = (0, 0, 1)
            report "i=" & to_string(i);
      end case;
    end loop;
    wait;
  end process stimuli_case;

end architecture test;

configuration CFG_TB_DECODER of TB_DECODER is
  for TEST
  end for;
end CFG_TB_DECODER;
