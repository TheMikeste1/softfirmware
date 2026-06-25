package ctrl is
  type TState is (
    Idle,
    TakePic, DelayTakePic, WaitExpTime,
    DelayMotor, WaitMotor,
    Broken, Recovery
  );
end package ctrl;

library ieee;
  use ieee.std_logic_1164.all;
  use work.ctrl.all;

entity main_ctrl is
  -- system signals: CLK, RESET
  -- control signals: TRIGGER, EXPOSE, MOTOR_READY, MOTOR_ERROR
  -- output signals: ERROR, TIMER_GO, MOTOR_GO
  port (
    clk         : in    std_ulogic;
    reset       : in    std_ulogic;
    trigger     : in    std_ulogic;
    expose      : in    std_ulogic;
    motor_ready : in    std_ulogic;
    motor_error : in    std_ulogic;
    i_error     : out   std_ulogic;
    timer_go    : out   std_ulogic;
    motor_go    : out   std_ulogic;
    state       : out   TState
  );
end entity main_ctrl;

architecture rtl of main_ctrl is
  -- The state machine has to control the exposure process:
  -- While in IDLE state, the device waits for a trigger signal
  -- Then the exposure controller is started and the main controller
  -- has to wait for the end of the exposure. Please note, that the
  -- exposure controller needs 1 clock cycle to react on input signal
  -- changes!
  -- After the picture has been taken, the film transport must be
  -- initiated and the camera has to wait for the motor to finish
  -- If an error occurs, the controller shall enter a BROKEN state
  -- to prevent any further damage to the film

  -- Signals to store the state information:
  signal r_state      : TState;
  signal r_next_state : TState;

begin
  state <= r_state;
  -- process to calculate the next state
  transition : process (reset, r_state, trigger, expose, motor_ready, motor_error) is
  begin
    r_next_state <= r_state;
    if reset = '1' then
      r_next_state <= Idle;
      timer_go     <= '0';
      motor_go     <= '0';
    else
      -- Keep the old state as default action
      -- Check all transitions
      case r_state is
        when Idle =>
          timer_go <= '0';
          motor_go <= '0';
          if trigger = '1' then
            r_next_state <= TakePic;
          end if;

        when TakePic =>
          timer_go     <= '1';
          r_next_state <= DelayTakePic;

        when DelayTakePic =>
          timer_go     <= '0';
          r_next_state <= WaitExpTime;

        when WaitExpTime =>
          if expose = '0' then
            r_next_state <= DelayMotor;
          end if;

        when DelayMotor =>
          motor_go     <= '1';
          r_next_state <= WaitMotor;

        when WaitMotor =>
          motor_go <= '0';
          if motor_error = '1' then
            r_next_state <= Broken;
          elsif motor_ready = '1' then
            r_next_state <= TakePic when trigger = '1' else Idle;
          end if;

        when Broken =>
          if trigger = '1' then
            r_next_state <= Recovery;
          end if;

        when Recovery =>
          if trigger = '0' then
            r_next_state <= Idle;
          end if;

        -- Other states
        when others =>
          assert false;
          r_next_state <= Idle;
          timer_go     <= '0';
          motor_go     <= '0';
      end case;
    end if;

  end process transition;

  -- Clocked process to update the FSM registers
  proc_name : process (clk, reset) is
  begin
    if (reset = '1') then
      -- Default system state
      r_state <= Idle;
    elsif (clk'event and clk = '1') then
      -- Update of register values
      r_state <= r_next_state;
    end if; -- end of clocked process
  end process proc_name;

  -- Concurrent statements to drive the output signals with STATE select
  i_error <= '1' when r_state = Broken else
             '0';
end architecture rtl;
