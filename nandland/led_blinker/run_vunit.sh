#!/usr/bin/env bash
script_dir="$(dirname -- "${BASH_SOURCE[0]:-$0}")" && readonly script_dir
podman run --rm \
    -v "$script_dir":/src:Z \
    -w /src \
    ghdl/vunit:gcc \
sh -c '
        export VUNIT_SIMULATOR=ghdl
        find . -name run.py -exec python3 {} "$@" \;
    ' sh "$@"
