#!/usr/bin/env bash
script_dir="$(dirname -- "${BASH_SOURCE[0]:-$0}")" && readonly script_dir
cd "$script_dir" || exit 1

python3 -m venv .venv
. .venv/bin/activate
python3 -m pip install -r requirements.txt
python3 ./generate_fusesoc_schema.py

./create_ghdl_venv.sh
