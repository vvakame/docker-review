#!/bin/bash -eux

# 2.3.0 2.4.0 2.5.0 のサポートは終了しました
# 3.0.0〜5.2.0 はDebian 10で凍結し、update反映外とします
versions=(5.3.0 5.4.0 5.5.0 5.6.0 5.7.0)

for version in "${versions[@]}"
do
    major=$(echo $version | cut -d "." -f 1)
    minor=$(echo $version | cut -d "." -f 2)
    dir_name=review-${major}.${minor}
    rm -rf ${dir_name}
    mkdir ${dir_name}
    cat Dockerfile | sed "s/^ENV REVIEW_VERSION .*$/ENV REVIEW_VERSION ${version}/" > ${dir_name}/Dockerfile
done
