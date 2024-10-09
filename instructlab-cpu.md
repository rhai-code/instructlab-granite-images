# Instructlab with CUDA support

## Pre-requisites

* Docker or Podman

Create a local folder for instruclab data e.g.

`mkdir ~/instructlab`

`export INSTRUCTLAB_LOCAL=~/instructlab`

Change the permissions on this folder:

`chmod 777 ~/instructlab`

## Download the granite-7b-lab model

### docker

docker run -v $INSTRUCTLAB_LOCAL:/instructlab/share:Z quay.io/redhatai/instructlab:1.0 ilab model download --repository instructlab/granite-7b-lab-gguf  --model-dir /instructlab/share/models --filename granite-7b-lab-Q4_K_M.gguf 

### podman

podman run -v $INSTRUCTLAB_LOCAL:/instructlab/share:Z quay.io/redhatai/instructlab:1.0 ilab model download --repository instructlab/granite-7b-lab-gguf  --model-dir /instructlab/share/models --filename granite-7b-lab-Q4_K_M.gguf 



## Serve the model

### docker

docker run --ipc=host --network host   -v $INSTRUCTLAB_LOCAL:/instructlab/share quay.io/redhatai/instructlab:1.0 ilab serve --model-path /instructlab/share/models/granite-7b-lab-Q4_K_M.gguf  

podman run --ipc=host  -v $INSTRUCTLAB_LOCAL:/instructlab/share quay.io/redhatai/instructlab:1.0 ilab serve --model-path /instructlab/share/models/granite-7b-lab-Q4_K_M.gguf  


## Chat with the model


docker run --ipc=host -it -p 8000:8000 --network host  quay.io/redhatai/instructlab:1.0 ilab chat  --endpoint-url http://localhost:8000/v1 -m /instructlab/share/models/granite-7b-lab-Q4_K_M.gguf

podman run --ipc=host -it -p 8000:8000 --network host  quay.io/redhatai/instructlab:1.0 ilab chat  --endpoint-url http://localhost:8000/v1 -m /instructlab/share/models/granite-7b-lab-Q4_K_M.gguf


