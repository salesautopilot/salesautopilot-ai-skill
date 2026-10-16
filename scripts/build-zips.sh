#!/usr/bin/env bash
# Builds the downloadable archives into dist/:
#   salesautopilot-plugin.zip  — whole plugin, .claude-plugin/plugin.json at the zip root
#                                (Team/Enterprise admins: claude.ai organization plugin upload)
#   <skill-name>.zip           — one per skill, the skill folder at the zip root
#                                (anyone: claude.ai Settings → Capabilities → Skills → Upload skill)
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
dist="$root/dist"
rm -rf "$dist"
mkdir -p "$dist"

(cd "$root/salesautopilot" && zip -qr -X "$dist/salesautopilot-plugin.zip" . -x '*.DS_Store')

for skill in "$root"/salesautopilot/skills/*/; do
  name="$(basename "$skill")"
  (cd "$root/salesautopilot/skills" && zip -qr -X "$dist/$name.zip" "$name" -x '*.DS_Store')
done

ls -1 "$dist"
