#!/usr/bin/env bash

set -euxo pipefail

###################################

rm -rfd ./packages/client/NextjsGraphqlApi

./node_modules/.bin/purescript-graphql-client-generator \
  --input-json ./schemas/schema.json --output ./packages/client/NextjsGraphqlApi --api NextjsGraphqlApi
