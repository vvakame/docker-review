#!/bin/sh -eux

docker build --tag vvakame/review:local-build .

git submodule init && git submodule update
cd sample-book && docker run -t --rm -v $(pwd):/book vvakame/review:local-build /bin/bash -ci "cd /book && ./setup.sh && npm run pdf"
