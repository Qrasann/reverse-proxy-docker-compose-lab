

set -euo pipefail

BASE_URL="${BASE_URL:-http://127.0.0.1}"

check_endpoint() {
  local path="$1"
  local expected="$2"


  echo "Checking ${BASE_URL}${path}"

  response="$(curl -fsS "${BASE_URL}${path}")"

  if [[ "$response" != *"$expected"* ]]; then
    echo "ERROR: ${path} returned unexpected response"
    echo "Expected to contain: $expected"
    echo "Actual response: $response"
    exit 1
  fi

  echo "OK: ${path}"

}

check_endpoint "/health" "OK"
check_endpoint "/api/" "Hello from ENV"
check_endpoint "/site1/" "SITE 1"
check_endpoint "/site2/" "SITE 2"

echo "All smoke tests passed"
#!/usr/bin/env bash

set -euo pipefail

BASE_URL="${BASE_URL:-http://127.0.0.1}"
SMOKE_RETRIES="${SMOKE_RETRIES:-10}"
SMOKE_DELAY="${SMOKE_DELAY:-2}"

check_endpoint() {
  local path="$1"
  local expected="$2"
  local response=""

  echo "Checking ${BASE_URL}${path}"

  for attempt in $(seq 1 "$SMOKE_RETRIES"); do
    if response="$(curl -fsS "${BASE_URL}${path}" 2>/tmp/smoke-test-error.log)"; then
      if [[ "$response" == *"$expected"* ]]; then
        echo "OK: ${path}"
        return 0
      fi

      echo "ERROR: ${path} returned unexpected response"
      echo "Expected to contain: $expected"
      echo "Actual response: $response"
      exit 1
    fi

    echo "Attempt ${attempt}/${SMOKE_RETRIES} failed for ${path}"
    cat /tmp/smoke-test-error.log || true
    sleep "$SMOKE_DELAY"
  done

  echo "ERROR: ${path} did not become available"
  exit 1
}

check_endpoint "/health" "OK"
check_endpoint "/api/" "Hello from ENV"
check_endpoint "/site1/" "SITE 1"
check_endpoint "/site2/" "SITE 2"

echo "All smoke tests passed"
