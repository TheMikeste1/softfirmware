#!/usr/bin/env bash
# Exit on any error
set -e

readonly sources=(disp_mux.vhd )
readonly tb=tb_disp_mux

script_dir="$(dirname -- "${BASH_SOURCE[0]:-$0}")" && readonly script_dir
cd "$script_dir"

echo "Analyze VHD"
# shellcheck disable=SC2068
ghdl -a ${sources[@]} $tb.vhd

echo "Elaborate TB"
ghdl -e $tb

echo "Run simulation"

ghdl -r $tb --wave=wave.ghw || true

echo "Waveform file written to: wave.ghw"
echo "To view it, run: gtkwave --dark wave.ghw"
