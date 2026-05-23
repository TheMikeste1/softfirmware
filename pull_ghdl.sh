#!/usr/bin/env bash
# Run to get GHDL

script_dir="$(dirname -- "${BASH_SOURCE[0]:-$0}")" && readonly script_dir
source "$script_dir/.env"

set -euo pipefail
podman pull ghdl/ghdl:${GHDL_TAG}
