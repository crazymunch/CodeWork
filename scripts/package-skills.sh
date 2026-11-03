#!/usr/bin/env bash
# Zips each skill for upload as an account skill (claude.ai > Settings > Capabilities > Skills).
# Account skills reach cloud sessions and local sessions alike.
set -euo pipefail
repo="$(cd "$(dirname "$0")/.." && pwd)"
out="$repo/dist"
mkdir -p "$out"
for dir in "$repo"/skills/*/; do
  name="$(basename "$dir")"
  rm -f "$out/$name.zip"
  (cd "$repo/skills" && zip -qr "$out/$name.zip" "$name")
  echo "dist/$name.zip"
done
