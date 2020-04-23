ARG NODE_VERSION=12

FROM circleci/node:${NODE_VERSION}

RUN mkdir -p /opt
WORKDIR /opt

# install some deps for cloud-sdk first as root
USER root
ENV DEBIAN_FRONTEND=noninteractive
ENV CLOUDSDK_PYTHON_SITEPACKAGES 1

RUN . /etc/os-release && \
    export CLOUD_SDK_REPO="cloud-sdk-$VERSION_CODENAME" && \
    echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update && \
    apt-get install -y rsync google-cloud-sdk kubectl

RUN gcloud config set disable_usage_reporting true
# for running node etc. use the circleci user from the base-image
USER circleci