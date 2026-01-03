#!/usr/bin/env bash
set -euo pipefail

REPO_RAW_BASE="https://raw.githubusercontent.com/mikeswanson/PiHoleController/installer"
TARGET_DIR="/var/www/html"

if [ "${EUID}" -ne 0 ]; then
  echo "Please run this script with sudo, e.g.:" >&2
  echo "  curl -fsSL ${REPO_RAW_BASE}/install.sh | sudo bash" >&2
  exit 1
fi

if ! command -v pihole >/dev/null 2>&1; then
  echo "Pi-hole is not installed or not on PATH. Aborting." >&2
  exit 1
fi

version_major="$(
  pihole -v 2>/dev/null \
    | sed -n 's/^[Pp]i-hole version is v\([0-9][0-9]*\).*/\1/p; s/^Core version is v\([0-9][0-9]*\).*/\1/p' \
    | head -n1
)"

if [ -z "${version_major}" ]; then
  echo "Unable to detect Pi-hole version. Aborting." >&2
  exit 1
fi

if [ "${version_major}" -lt 6 ]; then
  echo "Pi-hole ${version_major} detected. Pi-hole 6 or later is required." >&2
  exit 1
fi

tmp_dir="$(mktemp -d)"
cleanup() { rm -rf "${tmp_dir}"; }
trap cleanup EXIT

curl -fsSL "${REPO_RAW_BASE}/controller.html" -o "${tmp_dir}/controller.html"
curl -fsSL "${REPO_RAW_BASE}/controller.js" -o "${tmp_dir}/controller.js"

mv "${tmp_dir}/controller.html" "${tmp_dir}/controller.js" "${TARGET_DIR}/"
chmod 644 "${TARGET_DIR}/controller.html" "${TARGET_DIR}/controller.js"

echo "Pi-hole Controller installed/updated in ${TARGET_DIR}."
echo "Open: https://pi.hole/controller.html (or your Pi-hole hostname/IP)"
