library ieee;
  use ieee.std_logic_1164.all;

package p_display is

  type TDigits is array (2 downto 0) of integer range 0 to 10;

  type TDisplay is array (2 downto 0) of std_ulogic_vector(6 downto 0);

  constant SEG_0 : std_ulogic_vector(6 downto 0) := "0111111";
  constant SEG_1 : std_ulogic_vector(6 downto 0) := "0000011";
  constant SEG_2 : std_ulogic_vector(6 downto 0) := "1101101";
  constant SEG_3 : std_ulogic_vector(6 downto 0) := "1100111";
  constant SEG_4 : std_ulogic_vector(6 downto 0) := "1010011";
  constant SEG_5 : std_ulogic_vector(6 downto 0) := "1110110";
  constant SEG_6 : std_ulogic_vector(6 downto 0) := "1111110";
  constant SEG_7 : std_ulogic_vector(6 downto 0) := "0100011";
  constant SEG_8 : std_ulogic_vector(6 downto 0) := "1111111";
  constant SEG_9 : std_ulogic_vector(6 downto 0) := "1110111";
  constant SEG_E : std_ulogic_vector(6 downto 0) := "1111100";

  -- pragma translate_off

  procedure display_digit (
    signal display :TDisplay
  );
-- pragma translate_on
end package p_display;

-- pragma translate_off
  use std.textio.all;

package body p_display is
  ------------------------------
  --
  --            111111111112222
  --   123456789012345678901234
  --  1  #5##    ####    ####
  --  2 #    #  #    #  #    #
  --  3 4    0  #    #  #    #
  --  4 #    #  #    #  #    #
  --  5  #6##    ####    ####
  --  6 #    #  #    #  #    #
  --  7 3    1  #    #  #    #
  --  8 #    #  #    #  #    #
  --  9  #2##    ####    ####
  --
  ------------------------------

  constant ACTIVE_SEG : character := '#';
  constant EMPTY_SEG  : character := ' ';

  -- Width and height of a digit
  constant WIDTH  : integer := 8;
  constant HEIGHT : integer := 9;

  -- Datatypes to store the complete display in a matrix

  subtype TMatrixRow is bit_vector (1 to 3 * WIDTH);

  type TDispMatrix is array (1 to HEIGHT) of TMatrixRow;

  -- Definition of the appearance of the 6 segments

  subtype TDigitRow is bit_vector(1 to WIDTH);

  type TSegDef is array (1 to HEIGHT) of TDigitRow;

  type     TDigitDef is array (0 to 6) of TSegDef;
  constant DIGIT_DEF : TDigitDef :=
  (
    (
      "00000000", --   ....
      "00000010", --  .    #
      "00000010", --  .    0
      "00000010", --  .    #
      "00000000", --   ....
      "00000000", --  .    .
      "00000000", --  .    .
      "00000000", --  .    .
      "00000000"  --   ....
    ),

    (
      "00000000", --   ....
      "00000000", --  .    .
      "00000000", --  .    .
      "00000000", --  .    .
      "00000000", --   ....
      "00000010", --  .    #
      "00000010", --  .    1
      "00000010", --  .    #
      "00000000"  --   ....
    ),

    (
      "00000000", --   ....
      "00000000", --  .    .
      "00000000", --  .    .
      "00000000", --  .    .
      "00000000", --   ....
      "00000000", --  .    .
      "00000000", --  .    .
      "00000000", --  .    .
      "00111100"  --   #2##
    ),

    (
      "00000000", --   ....
      "00000000", --  .    .
      "00000000", --  .    .
      "00000000", --  .    .
      "00000000", --   ....
      "01000000", --  #    .
      "01000000", --  3    .
      "01000000", --  #    .
      "00000000"  --   ....
    ),

    (
      "00000000", --   ....
      "01000000", --  #    .
      "01000000", --  4    .
      "01000000", --  #    .
      "00000000", --   ....
      "00000000", --  .    .
      "00000000", --  .    .
      "00000000", --  .    .
      "00000000"  --   ....
    ),

    (
      "00111100", --   #5##
      "00000000", --  .    .
      "00000000", --  .    .
      "00000000", --  .    .
      "00000000", --   ....
      "00000000", --  .    .
      "00000000", --  .    .
      "00000000", --  .    .
      "00000000"  --   ....
    ),

    (
      "00000000", --   ....
      "00000000", --  .    .
      "00000000", --  .    .
      "00000000", --  .    .
      "00111100", --   #6##
      "00000000", --  .    .
      "00000000", --  .    .
      "00000000", --  .    .
      "00000000"  --  ....
    )
  );

  procedure display_digit (
    signal display :TDisplay
  ) is
    file outfile : TEXT open write_mode is "display.txt";

    variable l         : line;
    variable disp_text : string(TMatrixRow'range);

    variable disp_matrix : TDispMatrix;
    variable col_l       : integer;
    variable col_r       : integer;

  begin
    -- Clear the display
    disp_matrix := (others => (others => '0'));

    -- Loop over all digits
    for digit in TDisplay'range loop
      -- Calculate the left- and rightmost columns
      col_l := DIGIT * WIDTH + 1;
      col_r := DIGIT * WIDTH + WIDTH;

      -- Loop over all segments
      for segment in 0 to 6 loop
        if (display(DIGIT)(SEGMENT) = '1') then
          -- Copy the matrix to the final display
          -- Loop over all rows of the display
          for row in TSegDef'range loop
            disp_matrix(ROW)(col_l to col_r) := DISP_MATRIX(ROW)(col_l to col_r) or
                                                DIGIT_DEF(SEGMENT)(ROW);
          end loop;
        end if;
      end loop;
    end loop;

    -- Write the matrix to a textfile
    for i in TDispMatrix'range loop
      -- Start with an empty line
      disp_text := (others => EMPTY_SEG);

      for j in TMatrixRow'range loop
        if (DISP_MATRIX(I)(J) = '1') then
          disp_text(J) := ACTIVE_SEG;
        end if;
      end loop;

      -- Write the line
      write(l, disp_text);
      writeline(OUTFILE, l);
    end loop;

  end procedure display_digit;
end package body p_display;
-- pragma translate_on
