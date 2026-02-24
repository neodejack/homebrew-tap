set shell := ["bash", "-euo", "pipefail", "-c"]

[default]
list:
    @just --list --list-heading $'Hey Mr.Scott whatcha gonna do\n' --list-prefix '~> '

bump-rr:
  #!/usr/bin/env bash
  set -euo pipefail
  ./scripts/bump-rr.sh
  brew audit --strict neodejack/tap/rr
  if git diff --quiet -- Formula/rr.rb; then
    echo "No changes in Formula/rr.rb; skipping commit."
    exit 0
  fi
  version="$(sed -n 's#.*releases/download/\(v[^/"]*\)/.*#\1#p' Formula/rr.rb | head -n1)"
  git add Formula/rr.rb
  git commit -m "brew formula: bump rr to ${version}"

bump-rr-tag tag:
  #!/usr/bin/env bash
  set -euo pipefail
  ./scripts/bump-rr.sh --tag {{ tag }}
  brew audit --strict neodejack/tap/rr
  if git diff --quiet -- Formula/rr.rb; then
    echo "No changes in Formula/rr.rb; skipping commit."
    exit 0
  fi
  version="$(sed -n 's#.*releases/download/\(v[^/"]*\)/.*#\1#p' Formula/rr.rb | head -n1)"
  git add Formula/rr.rb
  git commit -m "brew formula: bump rr to ${version}"
