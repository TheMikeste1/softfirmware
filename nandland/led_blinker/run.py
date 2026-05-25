#!/usr/bin/env python3
"""Test runner using VUnit"""
from pathlib import Path

from vunit import VUnit, VUnitCLI
from vunit.ui import Results

cli = VUnitCLI()
cli.parser.add_argument("--with-coverage", action="store_true")
args = cli.parse_args()

vu = VUnit.from_args(args, compile_builtins=False)
vu.add_vhdl_builtins()
vu.add_osvvm()

# Silence GHDL warnings for VUnit internals
vu.set_compile_option(
    "ghdl.a_flags",
    ["-Wno-hide", "-Wno-shared"] # pyright: ignore[reportArgumentType]
)

lib = vu.add_library("led_blink")

project_dir = Path(__file__).parent
files = lib.add_source_files(project_dir / "*.vhd")
files.set_compile_option(
    "ghdl.a_flags",
    ["-Wall"]
)

if args.with_coverage:
    lib.set_compile_option("enable_coverage", True)
    lib.set_sim_option("enable_coverage", True)

def post_run(results: Results):
    """Post run actions."""
    if args.with_coverage:
        results.merge_coverage(file_name="coverage_merged")

vu.main(post_run=post_run)
