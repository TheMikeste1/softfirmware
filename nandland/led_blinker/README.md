> Source: <https://nandland.com/your-first-verilog-program-an-led-blinker>
>
> Project Requirements:
>
> Design HDL code that will blink an LED at a specified frequency of 100 Hz, 50 Hz, 10 Hz, or 1 Hz.
> For each of the blink frequencies, the LED will be set to 50% duty cycle (it will be on half the time).
> The LED frequency will be chosen via two switches which are inputs to the FPGA.
> There is an additional switch called LED_EN that needs to be '1' to turn on the LED.
> The FPGA will be driven by a 25 MHz oscillator.
>
> Let's first draw the truth table for the frequency selector:
> | Enable | Switch 1 | Switch 2 | LED Drive Frequency |
> |--------|----------|----------|---------------------|
> | 0      | –        | –        | (disabled)          |
> | 1      | 0        | 0        | 100 Hz              |
> | 1      | 0        | 1        | 50 Hz               |
> | 1      | 1        | 0        | 10 Hz               |
> | 1      | 1        | 1        | 1 Hz                |
>
> For this to work correctly there will be 4 inputs and 1 output. The signals will be:
> | Signal Name | Direction | Description                                |
> |-------------|-----------|--------------------------------------------|
> | i_clock     | Input     | 25 MHz Clock                               |
> | i_enable    | Input     | The Enable Switch (Logic 0 = No LED Drive) |
> | i_switch_1  | Input     | Switch 1 in the Truth Table above          |
> | i_switch_2  | Input     | Switch 2 in the Truth Table above          |
> | o_led_drive | Output    | The signal that drives the LED             |
