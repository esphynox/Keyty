#!/bin/zsh

set -euo pipefail

readonly SCRIPT_DIR="${0:A:h}"
readonly REPO_ROOT="${SCRIPT_DIR:h}"
readonly SCRIPT_NAME="$(basename "$0")"
readonly DEFAULT_APP_PATH="${REPO_ROOT}/build/release/Keyty.app"
readonly DEFAULT_OUTPUT_PATH="${REPO_ROOT}/dist/Keyty.dmg"
readonly DEFAULT_BACKGROUND_PATH="${REPO_ROOT}/Assets/Packaging/DMG/DmgBackground.png"
readonly DEFAULT_VOLUME_NAME="Keyty"
readonly DMGBUILD_SETTINGS_PATH="${SCRIPT_DIR}/dmgbuild-settings.py"
readonly DEFAULT_BACKEND="dmgbuild"
readonly PYTHON_BIN="${KEYTY_DMG_PYTHON:-python3}"

app_path="${DEFAULT_APP_PATH}"
output_path="${DEFAULT_OUTPUT_PATH}"
background_path="${DEFAULT_BACKGROUND_PATH}"
volume_name="${DEFAULT_VOLUME_NAME}"
backend="${KEYTY_DMG_BACKEND:-${DEFAULT_BACKEND}}"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} [options]

Build a drag-to-Applications DMG from a signed Keyty.app bundle.

Options:
  --app PATH           Path to the .app bundle (default: ${DEFAULT_APP_PATH})
  --output PATH        Output DMG path (default: ${DEFAULT_OUTPUT_PATH})
  --background PATH    Background PNG path (default: ${DEFAULT_BACKGROUND_PATH})
  --volume-name NAME   Mounted volume name (default: ${DEFAULT_VOLUME_NAME})
  --backend NAME       DMG backend: dmgbuild, auto, or finder (default: ${DEFAULT_BACKEND})
  -h, --help           Show this help

dmgbuild is the release-safe default. The Finder AppleScript backend is kept
for manual local packaging only; it mutates Finder metadata and should not be
used for signed release artifacts.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --app)
      app_path="$2"
      shift 2
      ;;
    --output)
      output_path="$2"
      shift 2
      ;;
    --background)
      background_path="$2"
      shift 2
      ;;
    --volume-name)
      volume_name="$2"
      shift 2
      ;;
    --backend)
      backend="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

app_path="${app_path:A}"
output_path="${output_path:A}"
background_path="${background_path:A}"

if [[ ! -d "${app_path}" ]]; then
  echo "App bundle not found at ${app_path}" >&2
  exit 1
fi

if [[ ! -f "${background_path}" ]]; then
  echo "Background image not found at ${background_path}" >&2
  exit 1
fi

if [[ "${backend}" != "auto" && "${backend}" != "dmgbuild" && "${backend}" != "finder" ]]; then
  echo "Unsupported backend '${backend}'. Expected 'auto', 'dmgbuild', or 'finder'." >&2
  exit 1
fi

readonly app_name="$(basename "${app_path}")"
readonly output_dir="${output_path:h}"
readonly output_name="${output_path:t:r}"

mkdir -p "${output_dir}"

has_dmgbuild() {
  command -v "${PYTHON_BIN}" >/dev/null 2>&1 && "${PYTHON_BIN}" -c "import dmgbuild" >/dev/null 2>&1
}

run_dmgbuild() {
  if [[ ! -f "${DMGBUILD_SETTINGS_PATH}" ]]; then
    echo "dmgbuild settings not found at ${DMGBUILD_SETTINGS_PATH}" >&2
    exit 1
  fi

  echo "Using dmgbuild backend"
  rm -f "${output_path}"
  "${PYTHON_BIN}" -m dmgbuild \
    -s "${DMGBUILD_SETTINGS_PATH}" \
    -D "app=${app_path}" \
    -D "background=${background_path}" \
    "${volume_name}" \
    "${output_path}"

  echo "Created ${output_path}"
}

if [[ "${backend}" == "dmgbuild" || ( "${backend}" == "auto" && -n "${CI:-}" ) ]]; then
  if ! has_dmgbuild; then
    echo "dmgbuild is required for the '${backend}' backend in this environment." >&2
    echo "Install it in a virtual environment from requirements-release.txt." >&2
    echo "Then set KEYTY_DMG_PYTHON to that environment's Python." >&2
    exit 1
  fi

  run_dmgbuild
  exit 0
fi

if [[ "${backend}" == "auto" ]] && has_dmgbuild; then
  run_dmgbuild
  exit 0
fi

echo "Using Finder AppleScript backend"

readonly temp_root="$(mktemp -d "${TMPDIR:-/tmp}/keyty-dmg.XXXXXX")"
readonly staging_dir="${temp_root}/staging"
readonly mount_dir="/Volumes/${volume_name}"
readonly temp_dmg="${temp_root}/${output_name}-rw.dmg"

mounted=0

cleanup() {
  if [[ ${mounted} -eq 1 ]]; then
    hdiutil detach "${mount_dir}" -quiet || hdiutil detach "${mount_dir}" -quiet -force || true
  fi
  rm -rf "${temp_root}"
}
trap cleanup EXIT

if [[ -e "${mount_dir}" ]]; then
  echo "Mount point already exists at ${mount_dir}; detach or rename the volume before retrying." >&2
  exit 1
fi

mkdir -p "${staging_dir}/.background"
ditto "${app_path}" "${staging_dir}/${app_name}"
cp "${background_path}" "${staging_dir}/.background/DmgBackground.png"
ln -s /Applications "${staging_dir}/Applications"
chflags hidden "${staging_dir}/.background"

size_kb="$(du -sk "${staging_dir}" | awk '{print $1}')"
size_kb="$((size_kb + 20480))"

hdiutil create \
  -quiet \
  -ov \
  -srcfolder "${staging_dir}" \
  -volname "${volume_name}" \
  -fs HFS+ \
  -fsargs "-c c=64,a=16,e=16" \
  -format UDRW \
  -size "${size_kb}k" \
  "${temp_dmg}"

hdiutil attach \
  -quiet \
  -readwrite \
  -noverify \
  -noautoopen \
  -mountpoint "${mount_dir}" \
  "${temp_dmg}"
mounted=1

chflags hidden "${mount_dir}/.background"

osascript <<EOF
tell application "Finder"
  tell disk "${volume_name}"
    open
    set current view of container window to icon view
    set toolbar visible of container window to false
    set statusbar visible of container window to false
    set bounds of container window to {120, 120, 632, 400}

    set theIconViewOptions to the icon view options of container window
    set arrangement of theIconViewOptions to not arranged
    set icon size of theIconViewOptions to 128
    set text size of theIconViewOptions to 12
    set background picture of theIconViewOptions to file ".background:DmgBackground.png"

    set position of item "${app_name}" of container window to {130, 122}
    set position of item "Applications" of container window to {382, 122}

    close
    open
    update without registering applications
    delay 2
  end tell
end tell
EOF

sync
hdiutil detach "${mount_dir}" -quiet
mounted=0

rm -f "${output_path}"
hdiutil convert \
  -quiet \
  -ov \
  -format UDZO \
  -imagekey zlib-level=9 \
  -o "${output_path}" \
  "${temp_dmg}"

echo "Created ${output_path}"
