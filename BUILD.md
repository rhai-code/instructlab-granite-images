# Building the images

## Set Hugging Face token

`export HF_TOKEN=xxxx`

## Build with podman

### granite-3.0-8b-instruct-Q4_K_M.gguf

`podman build --build-arg MODEL_FILENAME="granite-3.0-8b-instruct-Q4_K_M.gguf" --build-arg MODEL_DOWNLOAD_URL="https://huggingface.co/RedHatAI/granite-3.0-8b-instruct-GGUF/resolve/main/granite-3.0-8b-instruct-Q4_K_M.gguf" --build-arg HF_TOKEN="$HF_TOKEN" -f Containerfile-granite-cpu -t granite-3.0-8b-cpu .`

### granite-34b-code-instruct.Q4_K_M.gguf

`podman build -f Containerfile-granite-cuda --build-arg "MODEL_DOWNLOAD_URL=https://huggingface.co/ibm-granite/granite-34b-code-instruct-8k-GGUF/resolve/main/granite-34b-code-instruct.Q4_K_M.gguf" --build-arg "MODEL_FILENANE=granite-34b-code-instruct.Q4_K_M.gguf" -t granite-34b-code-cuda --secret=id=/run/secrets/hf-token,src=~/hf-token/token .`



## Build with docker:

### Install Docker if not present

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


## Install nvidia container toolkit

https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html

curl -s -L https://nvidia.github.io/libnvidia-container/stable/rpm/nvidia-container-toolkit.repo | \
  sudo tee /etc/yum.repos.d/nvidia-container-toolkit.repo

  sudo dnf install -y nvidia-container-toolkit

  sudo nvidia-ctk runtime configure --runtime=docker

  sudo systemctl restart docker


### granite-3.0-8b-instruct-Q4_K_M.gguf

`docker build --build-arg MODEL_FILENAME="granite-3.0-8b-instruct-Q4_K_M.gguf" --build-arg MODEL_DOWNLOAD_URL="https://huggingface.co/RedHatAI/granite-3.0-8b-instruct-GGUF/resolve/main/granite-3.0-8b-instruct-Q4_K_M.gguf" --build-arg HF_TOKEN="$HF_TOKEN" -f Containerfile-granite-cpu -t granite-3.0-8b-cpu .`

### granite-34b-code-instruct.Q4_K_M.gguf

`docker build -f Containerfile-granite-cuda --build-arg "MODEL_DOWNLOAD_URL=https://huggingface.co/ibm-granite/granite-34b-code-instruct-8k-GGUF/resolve/main/granite-34b-code-instruct.Q4_K_M.gguf" --build-arg "MODEL_FILENANE=granite-34b-code-instruct.Q4_K_M.gguf" -t granite-34b-code-cuda .`
