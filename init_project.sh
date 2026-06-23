#!/usr/bin/env bash
script_dir="$(realpath "$(dirname -- "${BASH_SOURCE[0]:-$0}")")" && readonly script_dir
cd "$script_dir" || exit 1

python3 -m venv .venv
. .venv/bin/activate
python3 -m pip install -r requirements.txt
python3 ./generate_fusesoc_schema.py

./create_ghdl_venv.sh

# shellcheck disable=SC2016
echo '#!/usr/bin/env bash
if ! (return 0 2>/dev/null); then
  echo "Error: This script must be sourced. Run: . $0" >&2
  exit 1
fi

. '"$script_dir/.venv_ghdl/bin/activate"'
. '"$script_dir/.venv/bin/activate" > "$script_dir/activate"
