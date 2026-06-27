#!/usr/bin/env bash
script_dir="$(dirname -- "${BASH_SOURCE[0]:-$0}")" && readonly script_dir
# Must be ran from deploy's directory
cd "$script_dir/vhdlweb" || exit 1
./deploy
