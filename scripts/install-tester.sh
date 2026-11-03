#!/usr/bin/env bash
# Sets up the tester workspace on the computer whose Chrome will run tests.
# Usage: scripts/install-tester.sh [target-dir]   (default: ~/claude-tester)
set -euo pipefail
repo="$(cd "$(dirname "$0")/.." && pwd)"
target="${1:-$HOME/claude-tester}"

mkdir -p "$target/.claude/skills"
cp "$repo/tester-workspace/CLAUDE.md" "$target/CLAUDE.md"
cp "$repo/tester-workspace/.claude/settings.json" "$target/.claude/settings.json"
rm -rf "$target/.claude/skills/browser-tester"
cp -R "$repo/skills/browser-tester" "$target/.claude/skills/browser-tester"

echo "Tester workspace ready at $target"
echo "Start it with:"
echo "  cd \"$target\" && claude remote-control --chrome"
