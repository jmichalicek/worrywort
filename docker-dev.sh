#!/bin/sh

export WORRYWORT_SOURCE_DIR=$PWD
docker-compose -p worrywort -f ./compose.yml up -d
docker attach worrywort_phoenix_1
docker-compose -p worrywort -f ./compose.yml down
