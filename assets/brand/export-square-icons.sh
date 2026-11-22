#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/../.." && pwd)"
source_icon="$root/assets/brand/icon-square.svg"
platform="$root/assets/kit/platform"

render() {
  rsvg-convert -w "$2" -h "$2" "$source_icon" -o "$1"
}

render "$platform/ios/apple-touch-icon.png" 180
catalog=$(python3 - "$platform/ios/AppIcon.appiconset/Contents.json" <<'PY'
import json
import sys

with open(sys.argv[1]) as catalog:
    for image in json.load(catalog)["images"]:
        points = float(image["size"].split("x")[0])
        scale = int(image["scale"].removesuffix("x"))
        print(image["filename"], int(points * scale))
PY
)
while read -r filename size; do
  render "$platform/ios/AppIcon.appiconset/$filename" "$size"
done <<< "$catalog"

for size in 48 72 96 144 192 512; do
  render "$platform/android/android-chrome-${size}x${size}.png" "$size"
done
render "$platform/android/play-store-icon.png" 512
for entry in mdpi:108 hdpi:162 xhdpi:216 xxhdpi:324 xxxhdpi:432; do
  render "$platform/android/mipmap-${entry%:*}/ic_launcher.png" "${entry#*:}"
done

printf 'Square icons regenerated: iOS catalog/touch, Android flat/legacy. Adaptive layers unchanged.\n'
