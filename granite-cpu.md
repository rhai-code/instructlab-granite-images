# Granite-7b-lab-gguf

This image contains the granite-7b-lab-gguf model and llama.cpp to serve the model.  The container can run in two modes, CLI to chat with the model, or serving the model for OpenAI API clients

## Pre-requisites

* Docker or Podman


## serve the model and use the CLI

### docker

`docker run --ipc=host -it  quay.io/redhatai/granite-7b-lab-gguf:1.0 `

### podman

`podman run   --ipc=host  -it quay.io/redhatai/granite-7b-lab-gguf:1.0`

## Serve the model for OpenAI Compatible clients


### docker

`docker run --network host --ipc=host -it  quay.io/redhatai/granite-7b-lab-gguf:1.0 -s `

### podman

`podman run  --network host --ipc=host  -it quay.io/redhatai/granite-7b-lab-gguf:1.0 -s`

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