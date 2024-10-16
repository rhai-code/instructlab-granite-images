# Granite-7b-lab-gguf with CUDA support


This image contains the granite-7b-lab-gguf model and llama.cpp to serve the model with CUDA support.  The container can run in two modes, CLI to chat with the model, or serving the model for OpenAI API clients

## Pre-requisites

* Docker or Podman
* CUDA Toolkit, tested with v12.6
* nvidia container toolkit

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

`docker run --runtime=nvidia --gpus all --ipc=host -it  redhat/granite-7b-lab-gguf-cuda `

### podman

`podman run --device nvidia.com/gpu=all   --ipc=host  -it redhat/granite-7b-lab-gguf-cuda`

## Serve the model for OpenAI Compatible clients


### docker

`docker run --runtime=nvidia --gpus all --network host --ipc=host -it  redhat/granite-7b-lab-gguf-cuda -s `

### podman

`podman run --device nvidia.com/gpu=all  --network host --ipc=host  -it redhat/granite-7b-lab-gguf-cuda -s`

## Passing LLAMA.CPP arguments

Arguments can be passed to llama.cpp by using environment variables prefixed with "LLAMA_".

For example, to pass the "--port" argument, set the environment variable "LLAMA_PORT" when runnig the container e.g.

`docker run --runtime=nvidia --gpus all --network host --ipc=host -it -e "LLAMA_PORT=8090" redhat/granite-7b-lab-gguf-cuda -s`

This will start the llama.cpp server listening on port 8090.

For a full list of llama.cpp arguments refer to the llama.cpp documentation:

* [server](https://github.com/ggerganov/llama.cpp/blob/master/examples/server/README.md)
* [CLI](https://github.com/ggerganov/llama.cpp/blob/master/examples/main/README.md#common-options)

### Test curl command

```
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
  ```