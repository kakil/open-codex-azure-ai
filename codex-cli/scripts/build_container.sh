#!/bin/bash

set -euo pipefail

SCRIPT_DIR=$(realpath "$(dirname "$0")")
trap "popd >> /dev/null" EXIT
pushd "$SCRIPT_DIR/.." >> /dev/null || {
  echo "Error: Failed to change directory to $SCRIPT_DIR/.."
  exit 1
}
npm install
npm run build
rm -rf ./dist/openai-codex-*.tgz
npm pack --pack-destination ./dist
mv ./dist/openai-codex-*.tgz ./dist/codex.tgz
docker build -t codex -f "./Dockerfile" .
