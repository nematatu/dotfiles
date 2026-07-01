#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

case "$(uname -s)" in
    Darwin)
        exec "${SCRIPT_DIR}/scripts/install-macos.sh"
        ;;
    Linux)
        exec "${SCRIPT_DIR}/scripts/install-ubuntu-wsl.sh"
        ;;
    *)
        echo "Unsupported OS: $(uname -s)" >&2
        exit 1
        ;;
esac
