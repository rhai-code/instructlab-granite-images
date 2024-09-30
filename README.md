# InstructLab + CUDA 12.2.2 drivers + Vllm + granite-7b-lab

This repository contains the Dockerfile to build a container image to run InstructLab workloads on NVIDIA GPUs using CUDA drivers.  Also included is the safetensors for the granite-7b-lab model and vllm to serve the model.

Running this image should allow users to perform InstructLab operations `generate`, `train`, and `serve` using a mounted volume to persist data.

## Pre-requisites

* Docker or Podman
* NVIDIA GPU driver
* nvidia container toolkit


### Install docker if not present

sudo dnf remove -y docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine


sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

sudo vi /etc/yum.repos.d/docker-ce.repo

replace docker-ce-stable baseurl

baseurl=https://download.docker.com/linux/centos/$releasever/$basearch/stable

sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin


### Install nvidia container toolkit

https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html

curl -s -L https://nvidia.github.io/libnvidia-container/stable/rpm/nvidia-container-toolkit.repo | \
  sudo tee /etc/yum.repos.d/nvidia-container-toolkit.repo

  sudo dnf install -y nvidia-container-toolkit

  sudo nvidia-ctk runtime configure --runtime=docker

  sudo systemctl restart docker



## Chat with the model

To chat with the granite-7b-lab model, create a docker network with:

`sudo docker network create instructLab`

Serve the model with

`sudo docker run --rm --runtime=nvidia --ipc=host  --name serve --network instructLab -p 8000:8000 quay.io/hayesphilip/instructlab:0.15  ilab serve --model-path  /instructlab/models/instructlab/granite-7b-lab  --gpus 4 --backend=vllm -- --host serve`

Once the model is served, chat with the model with:

`sudo docker run -it --runtime=nvidia --gpus all --network instructLab --name chat quay.io/hayesphilip/instructlab:0.15  ilab model chat --endpoint-url http://serve:8000/v1 `


## Generate and train

Set the number of GPUS in your system

`export GPUS=1`

Create a local folder for instruclab data e.g.

`mkdir ~/instructlab`

`export INSTRUCTLAB_LOCAL=~/instructlab`

Clone taxonomy locally e.g. to $INSTRUCTLAB_LOCAL https://github.com/instructlab/taxonomy.git

`git clone https://github.com/instructlab/taxonomy.git $INSTRUCTLAB_LOCAL/taxonomy`

Edit the taxonomy to add new knowledge

Run generate

`sudo docker run --rm --runtime=nvidia --gpus all --ipc=host -v $INSTRUCTLAB_LOCAL:/instructlab/share quay.io/hayesphilip/instructlab:0.15 ilab generate --model /instructlab/models/instructlab/granite-7b-lab  --gpus $GPUS --output-dir /instructlab/share/datasets`

Run train

`sudo docker run  --rm --runtime=nvidia --gpus all --ipc=host  -v $INSTRUCTLAB_LOCAL:/instructlab/share quay.io/hayesphilip/instructlab:0.15 ilab train --gpus $GPUS --data-path /instructlab/share/datasets/knowledge_train_msgs_2024-09-20T14_51_48.jsonl`

## building



`sudo dnf remove -y docker-buildx-plugin`

## Mac 

`docker run -v $INSTRUCTLAB_LOCAL:/instructlab/share instruct-cpu ilab model download --repository instructlab/granite-7b-lab-GGUF --filename granite-7b-lab-Q4_K_M.gguf --model-dir /instructlab/share/models`

`docker run --rm -v $INSTRUCTLAB_LOCAL:/instructlab/share --name serve --network host -p 8000:8000 instruct-cpu   ilab serve --model-path   /instructlab/share/models/granite-7b-lab-Q4_K_M.gguf`


 `docker run -it --rm  --name chat --network host instruct-cpu   ilab chat  --model /instructlab/share/models/granite-7b-lab-Q4_K_M.gguf`

 `docker run --rm  -v $INSTRUCTLAB_LOCAL:/instructlab/share instruct-cpu  ilab generate --model /instructlab/share/models/granite-7b-lab-Q4_K_M.gguf   --output-dir /instructlab/share/datasets` 