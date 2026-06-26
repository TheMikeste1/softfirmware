library ieee;
  use ieee.std_logic_1164.all;
  use work.p_display.all;
  use work.decoder;

entity camera is
  port (
    clk         : in    std_ulogic;
    reset       : in    std_ulogic;
    trigger     : in    std_ulogic;
    switch      : in    std_ulogic;
    keypad      : in    std_ulogic_vector(9 downto 0);
    motor_ready : in    std_ulogic;
    expose      : buffer std_ulogic;
    display     : out   TDisplay
  );
end entity camera;

architecture struct of camera is
  -- Camera components:
  -- DISP_DRV
  -- DECODER
  -- EXP_FF
  -- DISP_CTRL
  -- MOTOR_TIMER
  -- EXP_CTRL
  -- MAIN_CTRL

  -- All signals that are not present on the camera entity must be
  -- declared as internal signals
  signal w_key : TDigits;

begin

  -- I don't really wanna


  -- Instantiation of the components
  u_decoder : entity work.decoder(rtl_case)
    port map (
      keypad => keypad,
      key    => w_key
    );
end architecture struct;

configuration CFG_CAMERA of CAMERA is
  for STRUCT
-- The case-based architecture shall be selected for the DECODER
  end for;
end CFG_CAMERA;
