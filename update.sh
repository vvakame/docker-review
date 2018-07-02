#!/bin/bash -eux

rm -rf review-2.3
mkdir review-2.3
cat Dockerfile | sed "s/^ENV REVIEW_VERSION .*$/ENV REVIEW_VERSION 2.3.0/" > review-2.3/Dockerfile
cp -r noto review-2.3

rm -rf review-2.4
mkdir review-2.4
cat Dockerfile | sed "s/^ENV REVIEW_VERSION .*$/ENV REVIEW_VERSION 2.4.0/" > review-2.4/Dockerfile
cp -r noto review-2.4

rm -rf review-2.5
mkdir review-2.5
cat Dockerfile | sed "s/^ENV REVIEW_VERSION .*$/ENV REVIEW_VERSION 2.5.0/" > review-2.5/Dockerfile
cp -r noto review-2.5

rm -rf review-3.0
mkdir review-3.0
cat Dockerfile | sed "s/^ENV REVIEW_VERSION .*$/ENV REVIEW_VERSION 3.0.0.preview1/" > review-3.0/Dockerfile
cp -r noto review-3.0
