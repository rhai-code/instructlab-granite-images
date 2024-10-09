# Instructlab with CUDA support

This image contains the InstructLab CLI version 0.19.2 with CUDA support.  For usage examples, see below.

For full InstructLab workflow, i.e. synthetic data generation and training it's recommended to use a g6.12large instance from AWS (https://aws.amazon.com/ec2/instance-types/g6/) which has 4 x NVIDIA L4 Tensor Core GPUs with 24 GB of memory per GPU.
 
## Pre-requisites

* Docker or Podman
* CUDA Toolkit, tested with v12.6
* nvidia container toolkit

Set the number of GPUS in your system

`export GPUS=1`

Create a local folder for instruclab data e.g.

`mkdir ~/instructlab`

`export INSTRUCTLAB_LOCAL=~/instructlab`

Change the permissions on this folder:

`chmod 777 ~/instructlab`


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


## Download the granite-7b-lab model

### docker

docker run -v $INSTRUCTLAB_LOCAL:/instructlab/share quay.io/redhatai/instructlab-cuda:1.0 ilab model download --repository instructlab/granite-7b-lab  --model-dir /instructlab/share/models --hf-token blah

### podman

podman run -v $INSTRUCTLAB_LOCAL:/instructlab/share:Z quay.io/redhatai/instructlab-cuda:1.0 ilab model download --repository instructlab/granite-7b-lab  --model-dir /instructlab/share/models --hf-token blah

## Download the Mixtral-8x7B model for synthetic data generation

docker run -v $INSTRUCTLAB_LOCAL:/instructlab/share quay.io/redhatai/instructlab-cuda:1.0 ilab model download --repository TheBloke/Mixtral-8x7B-Instruct-v0.1-GPTQ  --model-dir /instructlab/share/models --hf-token xxx

podman run -v $INSTRUCTLAB_LOCAL:/instructlab/share:Z quay.io/redhatai/instructlab-cuda:1.0 ilab model download --repository TheBloke/Mixtral-8x7B-Instruct-v0.1-GPTQ   --model-dir /instructlab/share/models --hf-token xxx


## Serve the model

### docker

docker run --runtime=nvidia --gpus all --ipc=host --network host   -v $INSTRUCTLAB_LOCAL:/instructlab/share quay.io/redhatai/instructlab-cuda:1.0 ilab serve --model-path /instructlab/share/models/instructlab/granite-7b-lab --gpus $GPUS -- --host 0.0.0.0

podman run --device nvidia.com/gpu=all --ipc=host --network host   -v $INSTRUCTLAB_LOCAL:/instructlab/share quay.io/redhatai/instructlab-cuda:1.0 ilab serve --model-path /instructlab/share/models/instructlab/granite-7b-lab --gpus $GPUS -- --host 0.0.0.0

## Chat with the model


docker run --ipc=host -it  --network host  quay.io/redhatai/instructlab:1.0 ilab chat  --endpoint-url http://localhost:8000/v1 -m /instructlab/share/models/instructlab/granite-7b-lab

podman run --ipc=host -it --network host  quay.io/redhatai/instructlab:1.0 ilab chat  --endpoint-url http://localhost:8000/v1 -m /instructlab/share/models/instructlab/granite-7b-lab

## Run synthetic data generation


Clone taxonomy locally e.g. to $INSTRUCTLAB_LOCAL https://github.com/instructlab/taxonomy.git

`git clone https://github.com/instructlab/taxonomy.git $INSTRUCTLAB_LOCAL/taxonomy`

Edit the taxonomy to add new knowledge

### docker

docker run --rm --runtime=nvidia --gpus all --ipc=host -v $INSTRUCTLAB_LOCAL:/instructlab/share quay.io/redhatai/instructlab-cuda:1.0 ilab generate --model /instructlab/share/models/TheBloke/Mixtral-8x7B-Instruct-v0.1-GPTQ  --gpus $GPUS --output-dir /instructlab/share/datasets --pipeline full

### podman

podman run --rm --device nvidia.com/gpu=all  --gpus all --ipc=host -v $INSTRUCTLAB_LOCAL:/instructlab/share:Z quay.io/redhatai/instructlab-cuda:1.0 ilab generate --model /instructlab/share/models/TheBloke/Mixtral-8x7B-Instruct-v0.1-GPTQ  --gpus $GPUS --output-dir /instructlab/share/datasets --pipeline full

## Train the model 

### docker

docker run  --rm --runtime=nvidia --gpus all --ipc=host  -v $INSTRUCTLAB_LOCAL:/instructlab/share quay.io/redhatai/instructlab-cuda:1.0 ilab train --gpus $GPUS --data-path /instructlab/share/datasets/knowledge_train_msgs???? --pipeline accelerated --local --device cuda --model-path /instructlab/share/models/instructlab/granite-7b-lab


### podman

podman run  --rm --device nvidia.com/gpu=all --gpus all --ipc=host  -v $INSTRUCTLAB_LOCAL:/instructlab/share quay.io/redhatai/instructlab-cuda:1.0 ilab train --gpus $GPUS --data-path /instructlab/share/datasets/knowledge_train_msgs???? --pipeline accelerated --local --device cuda --model-path /instructlab/share/models/instructlab/granite-7b-lab

