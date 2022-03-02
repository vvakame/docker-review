#!/bin/bash -eux

docker build --tag vvakame/review:local-build .
docker run -t --rm vvakame/review:local-build /bin/bash -ci "mkdir /book && cd /book && review-init test && cd ./test && rake pdf && rake epub"
