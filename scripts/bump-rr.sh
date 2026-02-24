#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FORMULA_PATH="${ROOT_DIR}/Formula/rr.rb"
REPO_SLUG="neodejack/rr"

usage() {
  cat <<'EOF'
Usage:
  scripts/bump-rr.sh [--tag <tag>]

Examples:
  scripts/bump-rr.sh
  scripts/bump-rr.sh --tag v0.1.11
EOF
}

TAG=""
while [[ $# -gt 0 ]]; do
  case "$1" in
  --tag)
    if [[ $# -lt 2 ]]; then
      echo "error: --tag requires a value" >&2
      exit 1
    fi
    TAG="$2"
    shift 2
    ;;
  -h | --help)
    usage
    exit 0
    ;;
  *)
    echo "error: unknown argument: $1" >&2
    usage
    exit 1
    ;;
  esac
done

for bin in gh jq perl; do
  if ! command -v "$bin" >/dev/null 2>&1; then
    echo "error: required command not found: $bin" >&2
    exit 1
  fi
done

if [[ ! -f "$FORMULA_PATH" ]]; then
  echo "error: formula not found: $FORMULA_PATH" >&2
  exit 1
fi

GH_ARGS=(release view --repo "$REPO_SLUG" --json tagName,assets)
if [[ -n "$TAG" ]]; then
  GH_ARGS+=("$TAG")
fi

release_json="$(gh "${GH_ARGS[@]}")"

tag_name="$(jq -r '.tagName' <<<"$release_json")"
if [[ -z "$tag_name" || "$tag_name" == "null" ]]; then
  echo "error: failed to resolve release tag" >&2
  exit 1
fi

get_asset_field() {
  local asset_name="$1"
  local field_name="$2"

  jq -er --arg name "$asset_name" --arg field "$field_name" '
    .assets[]
    | select(.name == $name)
    | .[$field]
  ' <<<"$release_json" | head -n1
}

get_asset_sha() {
  local asset_name="$1"
  local digest

  digest="$(get_asset_field "$asset_name" "digest")"
  if [[ "$digest" =~ ^sha256:([0-9a-f]{64})$ ]]; then
    echo "${BASH_REMATCH[1]}"
    return 0
  fi

  echo "error: invalid or missing sha256 digest for ${asset_name}: ${digest}" >&2
  return 1
}

update_asset_entry() {
  local asset_name="$1"
  local asset_url="$2"
  local asset_sha="$3"
  local file_path="$4"

  ASSET_NAME="$asset_name" ASSET_URL="$asset_url" ASSET_SHA="$asset_sha" perl -0777 -i -pe '
    BEGIN {
      $asset = $ENV{"ASSET_NAME"};
      $url = $ENV{"ASSET_URL"};
      $sha = $ENV{"ASSET_SHA"};
      $pattern = qr{url "https://github\.com/neodejack/rr/releases/download/[^"]*/\Q$asset\E"\n\s*sha256 "[^"]+"};
      $replacement = qq{url "$url"\n      sha256 "$sha"};
    }

    $count = s{$pattern}{$replacement};
    die "error: expected exactly one match for $asset, found $count\n" unless $count == 1;
  ' "$file_path"
}

assets=(
  "rr_macos_arm.tar.gz"
  "rr_macos.tar.gz"
  "rr_linux_arm.tar.gz"
  "rr_linux.tar.gz"
)

for asset in "${assets[@]}"; do
  asset_url="$(get_asset_field "$asset" "url")"
  asset_sha="$(get_asset_sha "$asset")"
  update_asset_entry "$asset" "$asset_url" "$asset_sha" "$FORMULA_PATH"
done

echo "Updated ${FORMULA_PATH} to ${tag_name}"
