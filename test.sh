#!/bin/bash -eux

if [[ "${CI:-}" = "true" ]]; then
    docker buildx build --tag vvakame/review:local-build --platform linux/amd64,linux/arm64 .
else
    docker build --tag vvakame/review:local-build .
fi

git submodule init && git submodule update

if [[ "${CI:-}" = "true" ]]; then
    docker create -v /volumes --name book alpine:3.4 /bin/true
    docker cp $(pwd)/sample-book-v2p/ book:/volumes
    docker run -t --volumes-from book vvakame/review:local-build /bin/bash -ci "cd /volumes/sample-book-v2p && ./setup.sh && npm run pdf"
else
    docker run -t --rm -v $(pwd)/sample-book-v2p:/book vvakame/review:local-build /bin/bash -ci "cd /book && ./setup.sh && npm run pdf"
fi
