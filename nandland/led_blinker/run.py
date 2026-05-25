#!/usr/bin/env python3
"""Test runner using VUnit"""
from pathlib import Path

from vunit import VUnit

vu = VUnit.from_argv(compile_builtins=False)
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

vu.main()
