#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MCP_SCRIPT="${SCRIPT_DIR}/pob-mcp-docker.sh"

if ! command -v docker >/dev/null 2>&1; then
  echo "FAIL docker is not installed or not in PATH" >&2
  exit 1
fi

TMP_BUILDS="$(mktemp -d)"
cleanup() {
  rm -rf "${TMP_BUILDS}"
}
trap cleanup EXIT

cat > "${TMP_BUILDS}/smoke.xml" <<'XML'
<?xml version="1.0" encoding="UTF-8"?>
<PathOfBuilding>
  <Build level="1" className="Witch" ascendClassName="None"/>
</PathOfBuilding>
XML

export POB_BUILDS_DIR="${TMP_BUILDS}"
export POB_LUA_ENABLED=true
export POE_TRADE_ENABLED=false

echo "Starting PoB MCP smoke test..."
{
  printf '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"pob-docker-mcp-smoke","version":"0.1.0"}}}\n'
  printf '{"jsonrpc":"2.0","id":2,"method":"tools/list","params":{}}\n'
} | "${MCP_SCRIPT}" | grep -q '"tools"'
echo "Smoke passed."
