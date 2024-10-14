# Granite-7b-lab-gguf with CUDA support


This image contains the granite-7b-lab-gguf model and llama.cpp to serve the model.  Once the container starts the api should be available on http://127.0.0.1:8080/v1/chat/completions

## Pre-requisites

* Docker or Podman
* CUDA Toolkit, tested with v12.6
* nvidia container toolkit

Set the number of GPUS in your system

`export GPUS=1`

## Install nvidia container toolkit

https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html

curl -s -L https://nvidia.github.io/libnvidia-container/stable/rpm/nvidia-container-toolkit.repo | \
  sudo tee /etc/yum.repos.d/nvidia-container-toolkit.repo

sudo dnf install -y nvidia-container-toolkit

### Docker configuration

sudo nvidia-ctk runtime configure --runtime=docker

sudo systemctl restart docker

### Podman configuration

sudo nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml

## serve the model and use the CLI

### docker

`docker run --runtime=nvidia --gpus all --ipc=host -it  quay.io/redhatai/granite-7b-lab-gguf-cuda:1.0 `

### podman

`podman run --device nvidia.com/gpu=all   --ipc=host  -it quay.io/redhatai/granite-7b-lab-gguf-cuda:1.0`

## Serve the model for OpenAI Compatible clients


### docker

`docker run --runtime=nvidia --gpus all --network host --ipc=host -it  quay.io/redhatai/granite-7b-lab-gguf-cuda:1.0 -s `

### podman

`podman run --device nvidia.com/gpu=all  --network host --ipc=host  -it quay.io/redhatai/granite-7b-lab-gguf-cuda:1.0 -s`


## Chat with the model

curl http://0.0.0.0:8080/v1/chat/completions \
-H 'Content-Type: application/json' \
-d '{
      "model": "/instructlab/share/models/instructlab/granite-7b-lab",
      "messages": [
        {
          "role": "system",
          "content": "You are a helpful assistant. "
        },
        {
          "role": "user", "content": "Tell me a story about a red car"
        }
      ]
    }'