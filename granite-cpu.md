# Granite-7b-lab-gguf

This image contains the granite-7b-lab-gguf model and llama.cpp to serve the model.  Once the container starts the api should be available on http://127.0.0.1:8080/v1/chat/completions

## Pre-requisites

* Docker or Podman


## serve the model

### docker

`docker run --rm --ipc=host  --network host  quay.io/redhatai/granite-7b-lab-gguf:1.0 `

### podman

`podman run --rm  --ipc=host  --network host  quay.io/redhatai/granite-7b-lab-gguf:1.0`

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