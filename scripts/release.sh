#!/usr/bin/env bash
# Create an annotated version tag from pubspec.yaml (vMAJOR.MINOR.PATCH).
#
# Usage:
#   ./scripts/release.sh           # tag current pubspec version and push
#   ./scripts/release.sh --dry-run # print actions only
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

DRY_RUN=0
if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=1
fi

bash "$ROOT/scripts/check_version.sh"
version="$(sed -nE 's/^version:[[:space:]]*([0-9]+\.[0-9]+\.[0-9]+)(\+[0-9]+)?/\1/p' pubspec.yaml | head -1)"
tag="v${version}"

if ! grep -qE "^## \[${version}\]" CHANGELOG.md; then
  echo "error: CHANGELOG.md has no '## [$version]' section" >&2
  exit 1
fi

if git rev-parse "$tag" >/dev/null 2>&1; then
  echo "error: tag $tag already exists" >&2
  exit 1
fi

if [[ -n "$(git status --porcelain)" ]]; then
  echo "error: working tree is dirty; commit or stash first" >&2
  git status -sb
  exit 1
fi

echo "Running tests…"
if [[ "$DRY_RUN" -eq 1 ]]; then
  echo "dry-run: flutter test"
else
  flutter pub get
  dart analyze --fatal-infos
  flutter test
fi

echo "Creating annotated tag $tag"
if [[ "$DRY_RUN" -eq 1 ]]; then
  echo "dry-run: git tag -a $tag -m \"Release $tag\""
  echo "dry-run: git push origin $tag"
  exit 0
fi

git tag -a "$tag" -m "Release $tag"
git push origin "$tag"
echo "Pushed $tag — GitHub Actions release workflow should verify, create a GitHub Release, and publish to pub.dev."
