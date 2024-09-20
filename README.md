# Install docker if not present

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

sudo dnf remove -y docker-buildx-plugin





# Install nvidia container toolkit

curl -s -L https://nvidia.github.io/libnvidia-container/stable/rpm/nvidia-container-toolkit.repo | \
  sudo tee /etc/yum.repos.d/nvidia-container-toolkit.repo

  sudo dnf install -y nvidia-container-toolkit

  sudo nvidia-ctk runtime configure --runtime=docker

  sudo systemctl restart docker



# Chat with the model

sudo docker network create instructLab

sudo docker run --rm --runtime=nvidia --ipc=host  --name serve --network instructLab -p 8000:8000 quay.io/hayesphilip/instructlab:0.15  ilab serve --model-path  /instructlab/models/instructlab/granite-7b-lab  --gpus 4 --backend=vllm -- --host serve

sudo docker run -it --runtime=nvidia --gpus all --network instructLab --name chat quay.io/hayesphilip/instructlab:0.15  ilab model chat --endpoint-url http://serve:8000/v1 


# Generate and train

Clone taxonomy locally e.g. to /home/intruct/instructlab https://github.com/instructlab/taxonomy.git




sudo docker run --rm --runtime=nvidia --gpus all --ipc=host -v /home/instruct/instructlab:/instructlab/share quay.io/hayesphilip/instructlab:0.15 ilab generate --model /instructlab/models/instructlab/granite-7b-lab  --gpus 4 --output-dir /instructlab/share/datasets

sudo docker run  --rm --runtime=nvidia --gpus all --ipc=host  -v /home/instruct/instructlab:/instructlab/share quay.io/hayesphilip/instructlab:0.15 ilab train --gpus 4 --data-path /instructlab/share/datasets/knowledge_train_msgs_2024-09-20T14_51_48.jsonl