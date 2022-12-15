#!/bin/bash -eux

if [[ "${CI:-}" = "true" ]]; then
    docker buildx build --tag vvakame/review:local-build --platform linux/amd64,linux/arm64 .
fi

docker buildx build --tag vvakame/review:local-build --load .
docker run -t --rm vvakame/review:local-build /bin/bash -ci "mkdir /book && cd /book && review-init test && cd ./test && rake pdf && rake epub"
