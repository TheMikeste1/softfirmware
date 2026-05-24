#!/usr/bin/env python3
import os
from pathlib import Path

from vunit import VUnit

# Set the env so vunit works in the GHDL container
os.environ["VUNIT_GHDL_PATH"] = "./"

# 1. Initialize VUnit using command-line arguments
vu = VUnit.from_argv(compile_builtins=False)

# 2. Add built-in libraries (such as vunit_lib)
vu.add_vhdl_builtins()

# 3. Create a library
lib = vu.add_library("led_blink")

# 4. Add VHDL source files to the library
# This includes the design file and the testbench file
project_dir = Path(__file__).parent
lib.add_source_files(project_dir / "*.vhd")

# 5. Run the VUnit test suite
vu.main()
