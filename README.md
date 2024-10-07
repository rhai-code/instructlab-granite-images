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

`sudo docker run --rm --runtime=nvidia --gpus all --ipc=host -v $INSTRUCTLAB_LOCAL:/instructlab/share quay.io/redhat-user-workloads/ilab-community-tenant/instructlab/instructlab-cuda:on-pr-efce092ea85041bf84e50eb6391476dfe3d0b517 ilab generate --model /instructlab/share/models/instructlab/granite-7b-lab  --gpus $GPUS --output-dir /instructlab/share/datasets --pipeline full`

Run train

`sudo docker run  --rm --runtime=nvidia --gpus all --ipc=host  -v $INSTRUCTLAB_LOCAL:/instructlab/share quay.io/redhat-user-workloads/ilab-community-tenant/instructlab/instructlab-cuda:on-pr-efce092ea85041bf84e50eb6391476dfe3d0b517 ilab train --gpus $GPUS --data-path /instructlab/share/datasets/knowledge_train_msgs_2024-10-04T16_16_27.jsonl --pipeline accelerated --local --device cuda --model-path /instructlab/share/models/instructlab/granite-7b-lab`

## building



`sudo dnf remove -y docker-buildx-plugin`

## Mac 

`docker run -v $INSTRUCTLAB_LOCAL:/instructlab/share instruct-cpu ilab model download --repository instructlab/granite-7b-lab-GGUF --filename granite-7b-lab-Q4_K_M.gguf --model-dir /instructlab/share/models`

`docker run --rm -v $INSTRUCTLAB_LOCAL:/instructlab/share --name serve --network host -p 8000:8000 instruct-cpu   ilab serve --model-path   /instructlab/share/models/granite-7b-lab-Q4_K_M.gguf`


 `docker run -it --rm  --name chat --network host instruct-cpu   ilab chat  --model /instructlab/share/models/granite-7b-lab-Q4_K_M.gguf`

 `docker run --rm  -v $INSTRUCTLAB_LOCAL:/instructlab/share instruct-cpu  ilab generate --model /instructlab/share/models/granite-7b-lab-Q4_K_M.gguf   --output-dir /instructlab/share/datasets` 


sudo docker run  quay.io/redhat-user-workloads/ilab-community-tenant/granite-7b/granite-7b-lab-gguf:on-pr-41e56e0bf12f229be1d4c96d4632220d29b886ea

quay.io/redhat-user-workloads/ilab-community-tenant/granite-7b/granite-7b-lab-gguf-cuda:on-pr-41e56e0bf12f229be1d4c96d4632220d29b886ea 


sudo docker run  --rm --runtime=nvidia --gpus all --ipc=host  -p 8080:8080 quay.io/redhat-user-workloads/ilab-community-tenant/granite-7b/granite-7b-lab-gguf-cuda:on-pr-f5e2186b42fa60ce3461186398584d64c878236c

sha256:80c6f2e5dc0124aea8959ba2619e0304c3010391c982453d3fd18d4860a9bcccquay.io/redhat-user-workloads/ilab-community-tenant/granite-7b/granite-7b-lab-gguf:on-pr-69be042e14c16d3b41c80fc755d6c4c929f724d5-linux-x86-64
quay.io/redhat-user-workloads/ilab-community-tenant/granite-7b/granite-7b-lab-gguf@sha256:bad4c6fb706b9788b30dcd76e3d67916a67e5a8063a794247caaf045d023d662


docker run -v $INSTRUCTLAB_LOCAL:/instructlab/share quay.io/redhat-user-workloads/ilab-community-tenant/instructlab/instructlab:1f3839062872d1422511e3fe40a3e3dfcb80375c ilab model download --repository instructlab/granite-7b-lab-GGUF --filename granite-7b-lab-Q4_K_M.gguf --model-dir /instructlab/share/models



sudo docker run -v $INSTRUCTLAB_LOCAL:/instructlab/share quay.io/redhat-user-workloads/ilab-community-tenant/instructlab/instructlab-cuda:on-pr-289cf9875b09306380bb92f79d3b688cdf0900cd@sha256:c1ac82c9d087541b89e49dd55bd6db68a881d0e55ca793e32d079ea1079f7bc4 ilab model download --repository instructlab/granite-7b-lab  --model-dir /instructlab/share/models

sudo docker run -v $INSTRUCTLAB_LOCAL:/instructlab/share quay.io/redhat-user-workloads/ilab-community-tenant/instructlab/instructlab-cuda:on-pr-efce092ea85041bf84e50eb6391476dfe3d0b517 ilab model serve  --model-path /instructlab/share/models/instructlab/granite-7b-lab --backend vllm --gpus 4


ilab model download  

