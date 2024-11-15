# Building the images

## Set Hugging Face token

You will need a Hugging Face token with access to the huggingface.co/RedHatAI private repositories.  Create a file .hf-token containing the token

## Build with podman

### granite-3.0-8b-instruct-Q4_K_M.gguf

`podman build --build-arg MODEL_FILENAME="granite-3.0-8b-instruct-Q4_K_M.gguf" --build-arg MODEL_DOWNLOAD_URL="https://huggingface.co/RedHatAI/granite-3.0-8b-instruct-GGUF/resolve/main/granite-3.0-8b-instruct-Q4_K_M.gguf"  -f Containerfile-granite-cpu -t granite-3.0-8b-cpu --secret id=hf-token/token,src=./.hf-token,type=file .`

### granite-3.0-1b-a400m-instruct-Q4_K_M.gguf

`podman build --build-arg MODEL_FILENAME="granite-3.0-1b-a400m-instruct-Q4_K_M.gguf" --build-arg MODEL_DOWNLOAD_URL="https://huggingface.co/RedHatAI/granite-3.0-1b-a400m-instruct-GGUF/resolve/main/granite-3.0-1b-a400m-instruct-Q4_K_M.gguf"  -f Containerfile-granite-cpu -t granite-3.0-8b-cpu --secret id=hf-token/token,src=./.hf-token,type=file .`









