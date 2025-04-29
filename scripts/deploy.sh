#!/usr/bin/env bash
set -e
source .env
npx truffle migrate --reset --network rinkeby
