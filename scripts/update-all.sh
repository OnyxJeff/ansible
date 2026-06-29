#!/usr/bin/env bash
set -euo pipefail

# ----------------------------
# Inputs
# ----------------------------
GROUP="${1:-}"

if [[ -z "$GROUP" ]]; then
  echo "Usage: $0 <group>"
  echo "Example: $0 all"
  exit 1
fi

# ----------------------------
# Paths (repo-aware)
# ----------------------------
BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
export ANSIBLE_CONFIG="$BASE_DIR/ansible.cfg"
INVENTORY="$BASE_DIR/inventory/hosts.ini"
PLAYBOOK="$BASE_DIR/playbooks/maintenance/update-all.yml"

# ----------------------------
# Safety checks
# ----------------------------
echo "♻️ Updating nodes in $GROUP group using playbook: $PLAYBOOK"

mkdir -p "$(dirname "$INVENTORY")"

if [[ ! -f "$PLAYBOOK" ]]; then
  echo "❌ Missing playbook: $PLAYBOOK"
  exit 1
fi

# ----------------------------
# Bootstrap execution
# ----------------------------
echo "📡 Running update playbook..."

ansible-playbook \
  -i "$INVENTORY" \
  "$PLAYBOOK" \
  --limit "$GROUP" \
  --ask-become-pass \