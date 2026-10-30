# wf-jconnect — Tài liệu flow & wireframe J-Connect (M06)

Trang xem: **https://trion-org.github.io/wf-jconnect/**

| Thư mục | Nội dung |
| --- | --- |
| `docs/` | Trang publish lên GitHub Pages (portal `index.html`, wireframe, spec) |
| `docs/flow/` | Trang flow tương tác dựng bằng [Archify](https://github.com/tt-a1i/archify) — **không sửa tay** |
| `tools/docs/*.archify.md` | Nguồn của các trang flow; build bằng `tools/docs/build.sh` |
| `.github/workflows/pages.yml` | Tự deploy `docs/` khi push lên `main` |

Repo này được đồng bộ từ repo J_Connect bằng `make pages` (script `scripts/publish-pages.sh`). Hãy sửa ở repo gốc rồi đồng bộ sang, đừng sửa trực tiếp ở đây.
