#!/usr/bin/env bash
# Regenerate every derived app icon from assets/app-icon/filmcraft.svg (the canonical artwork; a
# 512-unit full-bleed tile with rx=112). filmcraft-small.svg is a lighter trace of the same drawing
# and is copied, not generated.
#
# Needs: resvg (brew install resvg / cargo install resvg) or rsvg-convert (librsvg). The .icns is
# written by iconutil on macOS, or by python3 elsewhere (PNG entries). The outputs are committed, so
# builds and packaging never need these tools.
#
#   packaging/icons.sh
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIR="$ROOT/assets/app-icon"
SVG="$DIR/filmcraft.svg"
APP_ID="com.iris.iriscine"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

if command -v resvg >/dev/null; then
  RENDERER=resvg
elif command -v rsvg-convert >/dev/null; then
  RENDERER=rsvg-convert
else
  echo "error: neither resvg nor rsvg-convert found (brew install resvg)" >&2
  exit 1
fi

# macOS icons follow Apple's grid: the tile body is 824 of 1024 px with a transparent margin, so
# the Dock shows it at the same size as other apps. 512 * 1024 / 824 = 636.27 units, margin 62.14.
MAC="$TMP/mac.svg"
sed 's/viewBox="0 0 512 512"/viewBox="-62.14 -62.14 636.27 636.27"/' "$SVG" >"$MAC"
grep -q 'viewBox="-62.14' "$MAC" || { echo "error: unexpected viewBox in $SVG" >&2; exit 1; }

render() {
  local input="$1" size="$2" output="$3"
  if [ "$RENDERER" = resvg ]; then
    resvg -w "$size" -h "$size" "$input" "$output" </dev/null
  else
    rsvg-convert -w "$size" -h "$size" "$input" -o "$output" </dev/null
  fi
}

render "$SVG" 1024 "$DIR/filmcraft-1024.png"
# Runtime window/Dock icon on macOS (apps/filmcraft/src/main.rs embeds it).
render "$MAC" 512 "$DIR/filmcraft-macos-512.png"

# Linux hicolor theme. Windows and Linux use the full-bleed tile.
for s in 16 24 32 48 64 128 256 512; do
  mkdir -p "$DIR/hicolor/${s}x${s}/apps"
  render "$SVG" "$s" "$DIR/hicolor/${s}x${s}/apps/$APP_ID.png"
done
mkdir -p "$DIR/hicolor/scalable/apps"
cp "$DIR/filmcraft-small.svg" "$DIR/hicolor/scalable/apps/$APP_ID.svg"

# Web app favicon and loading image.
render "$SVG" 128 "$ROOT/apps/filmcraft-web/web/favicon.png"

# Windows .ico.
ICO_PNGS=()
for s in 16 20 24 32 40 48 64 128 256; do
  render "$SVG" "$s" "$TMP/ico-$s.png"
  ICO_PNGS+=("$TMP/ico-$s.png")
done
(cd "$ROOT" && cargo run -q -p xtask -- ico "$DIR/filmcraft.ico" "${ICO_PNGS[@]}")

# macOS .icns.
if command -v iconutil >/dev/null; then
  SET="$TMP/filmcraft.iconset"
  mkdir -p "$SET"
  for s in 16 32 128 256 512; do
    render "$MAC" "$s" "$SET/icon_${s}x${s}.png"
    render "$MAC" $((s * 2)) "$SET/icon_${s}x${s}@2x.png"
  done
  iconutil -c icns -o "$DIR/filmcraft.icns" "$SET"
elif command -v python3 >/dev/null; then
  # The same Apple-grid renders, packed as PNG entries (the types iconutil writes for these sizes).
  ENTRIES=()
  for pair in icp4:16 icp5:32 ic07:128 ic08:256 ic09:512 ic11:32 ic12:64 ic13:256 ic14:512 ic10:1024; do
    render "$MAC" "${pair#*:}" "$TMP/${pair%%:*}.png"
    ENTRIES+=("${pair%%:*}" "$TMP/${pair%%:*}.png")
  done
  python3 -I -c '
import struct, sys
out, args = sys.argv[1], sys.argv[2:]
body = b""
for kind, path in zip(args[0::2], args[1::2]):
    data = open(path, "rb").read()
    body += kind.encode() + struct.pack(">I", len(data) + 8) + data
open(out, "wb").write(b"icns" + struct.pack(">I", len(body) + 8) + body)
' "$DIR/filmcraft.icns" "${ENTRIES[@]}"
else
  echo "warning: neither iconutil nor python3 found; filmcraft.icns not regenerated" >&2
fi
echo "icons written to $DIR"
