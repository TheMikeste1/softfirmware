#!/usr/bin/env bash
# Exit on any error
set -e

script_dir="$(dirname -- "${BASH_SOURCE[0]:-$0}")" && readonly script_dir
cd "$script_dir"

echo "Analyze VHD"
ghdl -a led_blink.vhd led_blink_tb.vhd

echo "Elaborate TB"
ghdl -e led_blink_tb

echo "Run simulation"

ghdl -r led_blink_tb --fst=wave.fst || true

echo "Waveform file written to: wave.fst"
echo "To view it, run: gtkwave --dark wave.fst"
