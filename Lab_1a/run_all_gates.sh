#!/usr/bin/env bash
set -euo pipefail

# ---------- Inputs (override via env) ----------
REGION="${REGION:-us-east-1}"
INSTANCE_ID="${INSTANCE_ID:-}"
SECRET_ID="${SECRET_ID:-}"
DB_ID="${DB_ID:-}"

# toggles pass-through
REQUIRE_ROTATION="${REQUIRE_ROTATION:-false}"
CHECK_SECRET_POLICY_WILDCARD="${CHECK_SECRET_POLICY_WILDCARD:-true}"
CHECK_SECRET_VALUE_READ="${CHECK_SECRET_VALUE_READ:-false}"
EXPECTED_ROLE_NAME="${EXPECTED_ROLE_NAME:-}"   # or set a real default

CHECK_PRIVATE_SUBNETS="${CHECK_PRIVATE_SUBNETS:-false}"

# output
OUT_JSON="${OUT_JSON:-gate_result.json}"

# ---------- Helpers ----------
now_utc() { date -u +"%Y-%m-%dT%H:%M:%SZ"; }
have_file() { [[ -f "$1" ]]; }

# Portable JSON escaping (macOS + Linux)
json_escape() {
  python3 -c 'import json,sys; print(json.dumps(sys.stdin.read())[1:-1])'
}

badge_color() {
  local status="$1"
  local warnings_count="$2"
  if [[ "$status" == "FAIL" ]]; then echo "RED"; return; fi
  if [[ "$warnings_count" -gt 0 ]]; then echo "YELLOW"; return; fi
  echo "GREEN"
}

# ---------- Preconditions ----------
if [[ -z "$INSTANCE_ID" || -z "$SECRET_ID" || -z "$DB_ID" ]]; then
  echo "ERROR: You must set INSTANCE_ID, SECRET_ID, and DB_ID." >&2
  echo "Example:" >&2
  echo "  REGION=us-east-1 INSTANCE_ID=i-03a... SECRET_ID=lab/rds/mysql-az7ux DB_ID=lab-mysql-az7ux ./run_all_gates.sh" >&2
  exit 1
fi

if ! have_file "./gate_secrets_and_role.sh" || ! have_file "./gate_network_db.sh"; then
  echo "ERROR: Missing required gate scripts in current directory." >&2
  echo "Expected:" >&2
  echo "  ./gate_secrets_and_role.sh" >&2
  echo "  ./gate_network_db.sh" >&2
  exit 1
fi

chmod +x ./gate_secrets_and_role.sh ./gate_network_db.sh || true

# ---------- Run Gate 1: Secrets + Role ----------
echo "=== Running Gate 1/2: secrets_and_role ==="
set +e
OUT_JSON="gate_secrets_and_role.json" \
REGION="$REGION" INSTANCE_ID="$INSTANCE_ID" SECRET_ID="$SECRET_ID" \
REQUIRE_ROTATION="$REQUIRE_ROTATION" \
CHECK_SECRET_POLICY_WILDCARD="$CHECK_SECRET_POLICY_WILDCARD" \
CHECK_SECRET_VALUE_READ="$CHECK_SECRET_VALUE_READ" \
EXPECTED_ROLE_NAME="$EXPECTED_ROLE_NAME" \
./gate_secrets_and_role.sh
rc1=$?
set -e

# ---------- Run Gate 2: Network + DB ----------
echo "=== Running Gate 2/2: network_db ==="
set +e
OUT_JSON="gate_network_db.json" \
REGION="$REGION" INSTANCE_ID="$INSTANCE_ID" DB_ID="$DB_ID" \
CHECK_PRIVATE_SUBNETS="$CHECK_PRIVATE_SUBNETS" \
./gate_network_db.sh
rc2=$?
set -e

# ---------- Determine overall ----------
overall_exit=0
overall_status="PASS"
if [[ "$rc1" -ne 0 || "$rc2" -ne 0 ]]; then
  overall_status="FAIL"
  overall_exit=2
fi

# ---------- Parse warnings count (best-effort without jq) ----------
warnings_1="$(grep -o '"warnings":[[][^]]*[]]' gate_secrets_and_role.json 2>/dev/null | wc -c | tr -d ' ')"
warnings_2="$(grep -o '"warnings":[[][^]]*[]]' gate_network_db.json 2>/dev/null | wc -c | tr -d ' ')"

warn_count=0
[[ "${warnings_1:-0}" -gt 15 ]] && warn_count=$((warn_count+1))
[[ "${warnings_2:-0}" -gt 15 ]] && warn_count=$((warn_count+1))

badge="$(badge_color "$overall_status" "$warn_count")"

# ---------- Emit combined JSON ----------
ts="$(now_utc)"
cat > "$OUT_JSON" <<EOF
{
  "gate": "all_gates",
  "timestamp_utc": "$ts",
  "region": "$(echo "$REGION" | json_escape)",
  "inputs": {
    "instance_id": "$(echo "$INSTANCE_ID" | json_escape)",
    "secret_id": "$(echo "$SECRET_ID" | json_escape)",
    "db_id": "$(echo "$DB_ID" | json_escape)"
  },
  "child_gates": [
    {
      "name": "secrets_and_role",
      "script": "gate_secrets_and_role.sh",
      "result_file": "gate_secrets_and_role.json",
      "exit_code": $rc1
    },
    {
      "name": "network_db",
      "script": "gate_network_db.sh",
      "result_file": "gate_network_db.json",
      "exit_code": $rc2
    }
  ],
  "badge": {
    "status": "$(echo "$badge" | json_escape)",
    "meaning": "GREEN=all pass, YELLOW=pass with warnings, RED=one or more failures"
  },
  "status": "$(echo "$overall_status" | json_escape)",
  "exit_code": $overall_exit
}
EOF

echo ""
echo "===== SEIR Combined Gate Summary ====="
echo "Gate 1 (secrets_and_role) exit: $rc1  -> gate_secrets_and_role.json"
echo "Gate 2 (network_db)       exit: $rc2  -> gate_network_db.json"
echo "--------------------------------------"
echo "BADGE:  $badge"
echo "RESULT: $overall_status"
echo "Wrote:  $OUT_JSON"
echo "======================================"
echo ""

exit "$overall_exit"
