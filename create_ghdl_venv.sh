#!/usr/bin/env bash
# Create a virtual environment for GHDL

script_dir="$(dirname -- "${BASH_SOURCE[0]:-$0}")" && readonly script_dir
source "$script_dir/.env"

readonly VENV_BIN_DIR=$script_dir/.venv_ghdl/bin
mkdir -p "$VENV_BIN_DIR"

# shellcheck disable=SC2016
echo 'function deactivate_ghdl() {
    # reset old environment variables
    if [ -n "${_GHDL_OLD_VIRTUAL_PATH:-}" ] ; then
        PATH="${_GHDL_OLD_VIRTUAL_PATH:-}"
        export PATH
        unset _GHDL_OLD_VIRTUAL_PATH
    fi

    # Call hash to forget past locations. Without forgetting
    # past locations the $PATH changes we made may not be respected.
    # See "man bash" for more details. hash is usually a builtin of your shell
    hash -r 2> /dev/null

    if [ ! "${1:-}" = "nondestructive" ] ; then
        # Self destruct!
        unset -f deactivate_ghdl
    fi
}

deactivate_ghdl nondestructive

_GHDL_OLD_VIRTUAL_PATH="$PATH"
PATH="'"$(realpath "${VENV_BIN_DIR}")"'":"$PATH"
export PATH

hash -r 2> /dev/null' > "$VENV_BIN_DIR/activate"

# shellcheck disable=SC2016
echo '#!/usr/bin/env bash
# shellcheck disable=SC2068
podman run --rm -v "$PWD":/src:Z -w /src ghdl/ghdl:'"$GHDL_TAG"' ghdl $@' > "$VENV_BIN_DIR/ghdl"
chmod +x "$VENV_BIN_DIR/ghdl"
