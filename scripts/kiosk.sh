#!/usr/bin/env bash
set -euo pipefail

# ----------------------------
# Inputs
# ----------------------------
GROUP="${1:-}"

if [[ -z "$HOST" ]]; then
  echo "Usage: $0 <host>"
  echo "Example: $0 svr-dashpi"
  exit 1
fi

# ----------------------------
# Paths (repo-aware)
# ----------------------------
BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
export ANSIBLE_CONFIG="$BASE_DIR/ansible.cfg"
INVENTORY="$BASE_DIR/inventory/hosts.yml"
PLAYBOOK="$BASE_DIR/playbooks/site.yml"

# ----------------------------
# Safety checks
# ----------------------------
echo "♻️ Updating node $HOST using playbook: $PLAYBOOK"

mkdir -p "$(dirname "$INVENTORY")"

if [[ ! -f "$PLAYBOOK" ]]; then
  echo "❌ Missing playbook: $PLAYBOOK"
  exit 1
fi

# ----------------------------
# Bootstrap execution
# ----------------------------
echo "📡 Running kiosk playbook..."

ansible-playbook \
  -i "$INVENTORY" \
  "$PLAYBOOK" \
  --limit "$HOST" \
  --ask-become-pass \