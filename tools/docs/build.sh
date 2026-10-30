#!/usr/bin/env bash
# Build docs/flow/*.html từ tools/docs/*.archify.md bằng Archify (giao diện tiếng Việt).
#   tools/docs/build.sh                          # build mọi trang
#   tools/docs/build.sh 116-2-trung-tam-chia-lead # build một trang
# ARCHIFY=<clone> dùng lại bản clone có sẵn; mặc định cache ở ~/.cache/archify.
set -euo pipefail
cd "$(dirname "$0")/../.."
ARCHIFY="${ARCHIFY:-$HOME/.cache/archify}"
OUT=docs/flow
if [ ! -d "$ARCHIFY/archify" ]; then
  git clone --depth 1 https://github.com/tt-a1i/archify "$ARCHIFY"
  (cd "$ARCHIFY" && npm install --silent)
fi
node tools/docs/archify/install-vi.mjs "$ARCHIFY"
mkdir -p "$OUT"

pages=("$@")
[ ${#pages[@]} -eq 0 ] && pages=($(cd tools/docs && ls *.archify.md | sed 's/\.archify\.md$//'))
for p in "${pages[@]}"; do
  node "$ARCHIFY/archify/bin/archify.mjs" finalize explainer "tools/docs/$p.archify.md" "$OUT/$p.html" \
    --writing off --json | node -e 'let s="";process.stdin.on("data",d=>s+=d).on("end",()=>{const r=JSON.parse(s);
      console.log(r.status.padEnd(5), process.argv[1]); if(r.status!=="pass"){console.log(JSON.stringify(r.diagnostics,null,1));process.exit(1)}})' "$p"
done
rm -f "$OUT"/*.delivery.json "$OUT"/*.finalize.json "$OUT"/*.finalize-summary.json "$OUT"/*.browser-check.json
