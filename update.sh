#!/bin/bash -eux

# 2.3.0 2.4.0 2.5.0 のサポートは終了しました
versions=(3.2.0 4.2.0 5.0.0 5.1.0 5.2.0)

for version in "${versions[@]}"
do
    major=$(echo $version | cut -d "." -f 1)
    minor=$(echo $version | cut -d "." -f 2)
    dir_name=review-${major}.${minor}
    rm -rf ${dir_name}
    mkdir ${dir_name}
    cat Dockerfile | sed "s/^ENV REVIEW_VERSION .*$/ENV REVIEW_VERSION ${version}/" > ${dir_name}/Dockerfile
    cp -r haranoaji ${dir_name}
    cp -r noto-otc ${dir_name}
done
