FROM nvidia/cuda:12.2.2-devel-ubi9 AS base
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility
# TODO research: possibly use the smaller cuda image?
#FROM nvidia/cuda:12.2.2-base-ubuntu22.04
# create a user, specific UID/GID is not necessisarily important, but designed to run as any `--user`
RUN set -eux; \
    groupadd -r ilab --gid=991; \
    useradd -r -g ilab --uid=991 --home-dir=/instructlab --shell=/bin/bash ilab; \
    install --verbose --directory --owner ilab --group ilab --mode 1777 /instructlab
ENV IL_VERSION=v0.18.4
WORKDIR /instructlab
RUN set -eux; \
    dnf -y update; \
    dnf install -y --setopt=install_weak_deps=False \
        automake \
        git \
        python3.11-devel \
        python3.11-pip \
    ; \
    rm -rf /var/lib/apt/lists/*;

RUN alias python3='/usr/bin/python3.11'

RUN dnf -y install libcudnn8 libcudnn8-devel cuda-cccl-12-4 libnccl-2.22.3-1+cuda12.4.x86_64

RUN pip3.11 install torch==2.3.1

RUN pip3.11 cache remove llama_cpp_python
RUN pip3.11 install --force-reinstall "llama_cpp_python[server]==0.2.79" --config-settings  cmake.args="-DLLAMA_CUDA=on"

RUN set -eux; \
     pip3.11 install --no-cache instructlab==$IL_VERSION;


RUN set -eux; \
    pip3.11 install instructlab[cuda]==$IL_VERSION; 
    # really remove pip cache

RUN set -eux; \
    pip3.11 install vllm@git+https://github.com/opendatahub-io/vllm@2024.08.01; \
    rm -rf /root/.cache 

RUN set -eux; \
    ilab config init --non-interactive --model-path /instructlab/granite-7b-lab

RUN ilab model download --repository instructlab/granite-7b-lab --model-dir /

ENV GIT_CONFIG_COUNT=1

ENV GIT_CONFIG_KEY_0=safe.directory

ENV GIT_CONFIG_VALUE_0=*
# COPY --from=build --link /target/ /