#!/usr/bin/env bash
set -euo pipefail

script_dir="$(realpath "$(dirname -- "${BASH_SOURCE[0]:-$0}")")" && readonly script_dir
if [[ ! -f "$script_dir/vhdlweb/template.config" ]]; then
  echo "Could not find vhdlweb. Has the submodule been pulled?" >%2
  exit 1
fi

cp "$script_dir/vhdlweb/template.config" "$script_dir/vhdlweb/deploy.config"
sed "s/SECRET_KEY = b''/SECRET_KEY = b'$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 16; echo "")'/" "$script_dir/vhdlweb/deploy.config" -i
sed "s%SRCDIR=\"/home/vhdlweb/vhdlweb/data/problems\"%SRCDIR=\"$script_dir/vhdlweb/data/problems\"%" "$script_dir/vhdlweb/deploy.config" -i
docker_image="$(grep DOCKER_IMAGE "$script_dir/vhdlweb/deploy.config")"
docker_image="${docker_image#*\"}"
docker_image="${docker_image%\"}"
readonly docker_image
docker pull "$docker_image"

sudo npm install -g netlistsvg # For diagrams

if command -v getenforce &> /dev/null; then
  echo "Running SELinux, adding modules. . ."
  cd "$script_dir" || {
    echo "Failed to add modules" >&2
    exit 1
  }

  checkmodule -M -m -o vhdlweb-ghdl.mod vhdlweb-ghdl.te
  semodule_package -o vhdlweb-ghdl.pp -m vhdlweb-ghdl.mod

  checkmodule -M -m -o vhdlweb-make.mod vhdlweb-make.te
  semodule_package -o vhdlweb-make.pp -m vhdlweb-make.mod

  checkmodule -M -m -o vhdlweb-sh.mod vhdlweb-sh.te
  semodule_package -o vhdlweb-sh.pp -m vhdlweb-sh.mod

  sudo semodule -X 300 -i vhdlweb-ghdl.pp
  sudo semodule -X 300 -i vhdlweb-make.pp
  sudo semodule -X 300 -i vhdlweb-sh.pp

  rm \
    vhdlweb-ghdl.mod vhdlweb-ghdl.pp \
    vhdlweb-make.mod vhdlweb-make.pp \
    vhdlweb-sh.mod vhdlweb-sh.pp
fi

echo "VHDL web ready; run $script_dir/vhdlweb/deploy"
