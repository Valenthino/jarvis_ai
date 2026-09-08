#!/usr/bin/env bash
set -euo pipefail

APP_ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)"
TEMPLATE="$APP_ROOT/server/config/server.coolify.yaml"
RUNTIME_CONFIG="$APP_ROOT/server/config/server.yaml"
VENV_PYTHON="${VIRTUAL_ENV:-/opt/venv}/bin/python"
: "${JARVIS_VOICE_NAME:=Jarvis}"
: "${ELEVENLABS_VOICE_ID:=}"
export JARVIS_VOICE_NAME ELEVENLABS_VOICE_ID

required=(JARVIS_HERMES_BASE_URL API_SERVER_KEY JARVIS_HUD_TOKEN JARVIS_PUBLIC_HOST)
for key in "${required[@]}"; do
  if [[ -z "${!key:-}" ]]; then
    printf 'Missing required Coolify environment variable: %s\n' "$key" >&2
    exit 1
  fi
done

mkdir -p "$APP_ROOT/server/logs"

"$VENV_PYTHON" - "$TEMPLATE" "$RUNTIME_CONFIG" <<'PY'
import os
import sys
from pathlib import Path

source, target = map(Path, sys.argv[1:])
text = os.path.expandvars(source.read_text(encoding="utf-8"))
target.write_text(text, encoding="utf-8")
PY

export JARVIS_CONFIG_PATH="$RUNTIME_CONFIG"
exec "$VENV_PYTHON" "$APP_ROOT/server/server.py"
