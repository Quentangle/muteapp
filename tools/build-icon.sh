#!/usr/bin/env bash
# Renders tools/icon.svg into the AppIcon.appiconset at all macOS sizes.
# Requires librsvg (rsvg-convert) and macOS sips. Run from repo root.
set -euo pipefail

SVG="tools/icon.svg"
OUT="muteapp/Assets.xcassets/AppIcon.appiconset"
TMP="$(mktemp -d)"

if ! command -v rsvg-convert >/dev/null 2>&1; then
    echo "rsvg-convert not found. Try: nix-shell -p librsvg --run 'tools/build-icon.sh'"
    exit 1
fi

# Render once at 1024 then downsample with sips for crisper smaller sizes.
rsvg-convert -w 1024 -h 1024 "$SVG" -o "$TMP/icon-1024.png"

for size in 512 256 128 64 32 16; do
    sips -z "$size" "$size" "$TMP/icon-1024.png" --out "$TMP/icon-${size}.png" >/dev/null
done

cp "$TMP/icon-1024.png" "$OUT/icon-1024.png"
for size in 512 256 128 64 32 16; do
    cp "$TMP/icon-${size}.png" "$OUT/icon-${size}.png"
done

rm -rf "$TMP"
echo "Wrote icon PNGs to $OUT"
