#!/usr/bin/env bash
if command -v getenforce &> /dev/null; then
  echo "Running SELinux, removing modules. . ."
  sudo semodule -X 300 -r vhdlweb-ghdl
  sudo semodule -X 300 -r vhdlweb-make
  sudo semodule -X 300 -r vhdlweb-sh
fi
