#!/bin/bash

source repo/bin/build.sh

### ---------------------------------------------------------------------------

msg "CREATING DOCKER IMAGE"
cd ..
[ "$1" ] && tag_param="-t $1"
docker build $tag_param .
