#!/usr/bin/env bash

set -euxo pipefail

###################################

generate-halogen-css-modules \
  -d ./packages/client

###################################

# sd --flags c "^import ([\w\.]+) (\(.+\) )as ([\w\.]+)" 'import $1 as $3' $(fd --type f ".purs" ./)

update-module-name-purs \
  -d ./packages/api-server \
  -d ./packages/api-server-exceptions \
  -d ./packages/api-server-config \
  -d ./packages/client \
  -d ./packages/client-tests \
  -d ./packages/client-webpack \
  -d ./packages/db-tests \
  -d ./packages/feature-tests \
  -d ./packages/src \
  -d ./packages/worker
