#!/bin/bash

cd $(git rev-parse --show-toplevel)
docker run --rm \
  --volume=$PWD:/check mstruebing/editorconfig-checker \
  /ec --exclude 'markdown|linux-amd64$|\.p12$'
