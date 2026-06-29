#!/usr/bin/env bash
set -euo pipefail

# ----------------------------
# Inputs
# ----------------------------
HOST="${1:-}"
USER="${2:-pi}"
NAME="${3:-}"

if [[ -z "$HOST" || -z "$NAME" ]]; then
  echo "Usage: $0 <ip> <ssh-user> <inventory-name>"
  echo "Example: $0 10.100.0.11 pi potentpi1"
  exit 1
fi

# ----------------------------
# Paths (repo-aware)
# ----------------------------
BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
export ANSIBLE_CONFIG="$BASE_DIR/ansible.cfg"
INVENTORY="$BASE_DIR/inventory/hosts.ini"
PLAYBOOK="$BASE_DIR/playbooks/bootstrap/node.yml"

# ----------------------------
# Safety checks
# ----------------------------
echo "🚀 Onboarding node: $NAME ($HOST) as $USER"

mkdir -p "$(dirname "$INVENTORY")"

if [[ ! -f "$PLAYBOOK" ]]; then
  echo "❌ Missing playbook: $PLAYBOOK"
  exit 1
fi

# ----------------------------
# Prevent duplicates
# ----------------------------
if grep -qE "^$NAME[[:space:]]" "$INVENTORY" 2>/dev/null; then
  echo "⚠️  Node '$NAME' already exists in inventory. Skipping add."
else
  echo "🧾 Writing to inventory..."

  cat >> "$INVENTORY" <<EOF

$NAME ansible_host=$HOST ansible_user=$USER
EOF

  echo "✅ Inventory updated"
fi

# ----------------------------
# Temp bootstrap inventory
# ----------------------------
TMP_INV=$(mktemp)

cat > "$TMP_INV" <<EOF
[new_nodes]
$NAME ansible_host=$HOST ansible_user=$USER
EOF

# ----------------------------
# Bootstrap execution
# ----------------------------
echo "📡 Running bootstrap playbook (password SSH required once)..."

ansible-playbook \
  -i "$TMP_INV" \
  "$PLAYBOOK" \
  --ask-pass \
  --ssh-common-args='-o StrictHostKeyChecking=no'

# ----------------------------
# Verify key-based access
# ----------------------------
echo "🔐 Verifying SSH key access..."

ansible -i "$TMP_INV" new_nodes -m ping

rm -f "$TMP_INV"

echo "🎉 Node successfully onboarded: $NAME"