#!/usr/bin/env bash
# Create a virtual environment for GHDL

# script_dir="$(dirname -- "${BASH_SOURCE[0]:-$0}")" && readonly script_dir
script_dir="$(realpath "$(dirname -- "${BASH_SOURCE[0]:-$0}")")" && readonly script_dir
source "$script_dir/.env"

readonly VENV_BIN_DIR=$script_dir/.venv_ghdl/bin
mkdir -p "$VENV_BIN_DIR"

# shellcheck disable=SC2016
cat << EOF  > "$VENV_BIN_DIR/activate"
#!/usr/bin/env bash
function deactivate_ghdl() {
    # reset old environment variables
    if [ -n "\${_GHDL_OLD_VIRTUAL_PATH:-}" ] ; then
        PATH="\${_GHDL_OLD_VIRTUAL_PATH:-}"
        export PATH
        unset _GHDL_OLD_VIRTUAL_PATH
    fi

    # Call hash to forget past locations. Without forgetting
    # past locations the \$PATH changes we made may not be respected.
    # See "man bash" for more details. hash is usually a builtin of your shell
    hash -r 2> /dev/null

    if [ ! "\${1:-}" = "nondestructive" ] ; then
        # Self destruct!
        unset -f deactivate_ghdl
    fi
}

deactivate_ghdl nondestructive

_GHDL_OLD_VIRTUAL_PATH="\$PATH"
PATH="$VENV_BIN_DIR:\$PATH"
export PATH

hash -r 2> /dev/null
EOF

cat << EOF > "$VENV_BIN_DIR/ghdl"
#!/usr/bin/env bash
# shellcheck disable=SC2068
podman run --rm -v "$script_dir":"$script_dir":Z -w "\$PWD" hdlc/ghdl:yosys ghdl "\$@"
EOF
chmod +x "$VENV_BIN_DIR/ghdl"

cat << EOF > "$VENV_BIN_DIR/yosys"
#!/usr/bin/env bash
# shellcheck disable=SC2068
podman run --rm -v "$script_dir":"$script_dir":Z -w "\$PWD" hdlc/ghdl:yosys yosys "\$@"
EOF
chmod +x "$VENV_BIN_DIR/yosys"

cat << EOF > "$VENV_BIN_DIR/svg-describe"
#!/usr/bin/env bash
set -euo pipefail
file="\$1" && readonly file
entity="\$2" && readonly entity

ghdl -a "\$file"
yosys -m ghdl -p "ghdl \$entity; prep -top \$entity; write_json -compat-int \$entity.json"
netlistsvg "\$entity.json" -o "\$entity.svg"
sed -i 's/<line /<line stroke="#000" /g' "\$entity.svg" # Some viewers don't treat lines without strokes correctly

echo ""
echo "\$entity rendered to \$entity.svg"
xdg-open "\$entity.svg"
EOF
chmod +x "$VENV_BIN_DIR/svg-describe"
