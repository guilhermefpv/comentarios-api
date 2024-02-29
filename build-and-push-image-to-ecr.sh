#!/bin/bash

CI_APPLICATION_REPOSITORY="<aws-ID>.dkr.ecr.us-east-1.amazonaws.com/comentarios-api"
CI_APPLICATION_TAG="latest"
ECR_HOST="<aws-ID>.dkr.ecr.us-east-1.amazonaws.com"
set -euxo pipefail

echo "Starting ./bin/build-and-push-image-to-ecr"

# validate presence of these vars:
: "${CI_APPLICATION_REPOSITORY}"
: "${CI_APPLICATION_TAG}"
: "${ECR_HOST}"

# log in to the amazon ecr docker registry
aws ecr get-login-password | docker login --username AWS --password-stdin "$ECR_HOST"

# build docker image
docker pull "$CI_APPLICATION_REPOSITORY:latest" || true
# docker build -t $REPOSITORY_URL:latest .
docker build --cache-from "$CI_APPLICATION_REPOSITORY:latest" -t "$CI_APPLICATION_REPOSITORY:$CI_APPLICATION_TAG" -t "$CI_APPLICATION_REPOSITORY:latest" .

# push image to amazon ecr
docker push "$CI_APPLICATION_REPOSITORY:$CI_APPLICATION_TAG"
docker push "$CI_APPLICATION_REPOSITORY:latest"

echo "Finished ./bin/build-and-push-image-to-ecr"