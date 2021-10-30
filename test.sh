#!/bin/bash -eux

docker build --privileged=true --tag vvakame/review:local-build .

git submodule init && git submodule update

if [[ "${CI:-}" = "true" ]]; then
    docker create -v /volumes --name book alpine:3.4 /bin/true
    docker cp $(pwd)/sample-book-v2/ book:/volumes
    docker run -t --volumes-from book vvakame/review:local-build /bin/bash -ci "cd /volumes/sample-book-v2 && ./setup.sh && npm run pdf"
else
    docker run -t --rm -v $(pwd)/sample-book-v2:/book vvakame/review:local-build /bin/bash -ci "cd /book && ./setup.sh && npm run pdf"
fi
