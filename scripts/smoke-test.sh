#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${BASE_URL:-http://127.0.0.1}"
SMOKE_RETRIES="${SMOKE_RETRIES:-10}"
SMOKE_DELAY="${SMOKE_DELAY:-2}"
EXPECTED_MESSAGE="${MESSAGE:-Hello from ENV}"

check_endpoint() {
  local path="$1"
  local expected="$2"
  local response=""
  local attempt

  echo "Checking ${BASE_URL}${path}"
  for ((attempt = 1; attempt <= SMOKE_RETRIES; attempt++)); do
    if response="$(curl --max-time 6 -fsS "${BASE_URL}${path}")"; then
      if [[ "$response" == *"$expected"* ]]; then
        echo "OK: $path"
        return 0
      fi

      printf 'ERROR: %s returned unexpected response\nExpected: %s\nActual: %s\n' "$path" "$expected" "$response" >&2
      return 1
    fi

    echo "Attempt ${attempt}/${SMOKE_RETRIES} failed for ${path}"
    if ((attempt < SMOKE_RETRIES)); then
      sleep "$SMOKE_DELAY"
    fi
  done

  echo "ERROR: ${path} did not become available" >&2
  return 1
}

check_endpoint "/health" "OK"
check_endpoint "/api/" "$EXPECTED_MESSAGE"
check_endpoint "/site1/" "SITE 1"
check_endpoint "/site2/" "SITE 2"
echo "All smoke tests passed"
