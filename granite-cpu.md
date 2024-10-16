# Granite-7b-lab-gguf

This image contains the granite-7b-lab-gguf model and llama.cpp to serve the model.  The container can run in two modes, CLI to chat with the model, or serving the model for OpenAI API clients

## Pre-requisites

* Docker or Podman


## serve the model and use the CLI

### docker

`docker run --ipc=host -it  redhat/granite-7b-lab-gguf `

### podman

`podman run   --ipc=host  -it redhat/granite-7b-lab-gguf`

## Serve the model for OpenAI Compatible clients


### docker

`docker run --network host --ipc=host -it  redhat/granite-7b-lab-gguf -s `

### podman

`podman run  --network host --ipc=host  -it redhat/granite-7b-lab-gguf -s`


## Passing LLAMA.CPP arguments

Arguments can be passed to llama.cpp by using environment variables prefixed with "LLAMA_".

For example, to pass the "--port" argument, set the environment variable "LLAMA_PORT" when running the container e.g.

`docker run --network host --ipc=host -it -e "LLAMA_PORT=8090" redhat/granite-7b-lab-gguf -s`

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