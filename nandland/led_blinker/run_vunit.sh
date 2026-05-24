#!/usr/bin/env bash
script_dir="$(dirname -- "${BASH_SOURCE[0]:-$0}")" && readonly script_dir
podman run --rm \
    -v "$script_dir":/src:Z \
    -w /src \
    ghdl/vunit:gcc \
sh -c '
    VUNIT_SIMULATOR=ghdl; \
    for f in $(find ./ -name 'run.py'); do python3 $f; done \
  '
