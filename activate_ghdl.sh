#!/usr/bin/env bash
# Source to activate GHDL
source "$(dirname -- "${BASH_SOURCE[0]:-$0}")/.env"

function ghdl()
{
    if [[ ! -v GHDL_TAG ]]; then
        echo "GHDL_TAG must be set to the desired GHDL container version, e.g. 7.0.0-dev-gcc-ubuntu-24.04." >&2
        return 1
    fi

    # shellcheck disable=SC2068
    podman run --rm -v "$PWD":/src -w /src ghdl/ghdl:"$GHDL_TAG" ghdl $@
}

function deactivate_ghdl()
{
    unset -f ghdl
    unset -f deactivate_ghdl
}
