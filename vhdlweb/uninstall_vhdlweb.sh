#!/usr/bin/env bash
script_dir="$(dirname -- "${BASH_SOURCE[0]:-$0}")" && readonly script_dir
cd "$script_dir" || exit 1

git config --unset submodule.vhdlweb.ignore
git -C "$script_dir/vhdlweb" restore .

if command -v getenforce &> /dev/null; then
  echo "Running SELinux, removing modules. . ."
  sudo semodule -X 300 -r vhdlweb-ghdl
  sudo semodule -X 300 -r vhdlweb-make
  sudo semodule -X 300 -r vhdlweb-sh
fi
