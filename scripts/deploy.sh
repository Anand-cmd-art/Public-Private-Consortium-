#!/usr/bin/env bash
set -e

# Load environment (only needed if you reference .env in migrations)
source "$(dirname "$0")/../.env"

# Which network?  default to development
NETWORK=${1:-development}

echo "→ Migrating to $NETWORK…"
npx truffle migrate --reset --network "$NETWORK"
