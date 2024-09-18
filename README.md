# Install docker

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

vi /etc/yum.repos.d/docker-ce.repo

replace docker-ce-stable baseurl

baseurl=https://download.docker.com/linux/centos/$releasever/$basearch/stable

sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

 sudo cat <<EOF >> /etc/docker/daemon.json
{
    "runtimes": {
        "nvidia": {
            "args": [],
            "path": "nvidia-container-runtime"
        }
    },
    "default-runtime": "nvidia"
}
EOF

# instructlab-image
<!-- 
Install nvidia drivers

sudo dnf install kernel-devel-$(uname -r) kernel-headers-$(uname -r)

sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm

sudo dnf config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/$distro/$arch/cuda-$distro.repo

sudo dnf config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/$distro/$arch/cuda-$distro.repo

sudo dnf clean expire-cache

sudo dnf module install nvidia-driver:open-dkms -->


# Install nvidia container toolkit

curl -s -L https://nvidia.github.io/libnvidia-container/stable/rpm/nvidia-container-toolkit.repo | \
  sudo tee /etc/yum.repos.d/nvidia-container-toolkit.repo

  sudo dnf install -y nvidia-container-toolkit

  sudo nvidia-ctk runtime configure --runtime=docker

  sudo systemctl restart docker

  sudo docker run --rm --runtime=nvidia --gpus all nvidia/cuda:12.2.2-devel-ubi9  tail -f /dev/null

    sudo docker run --rm --runtime=nvidia --gpus all instruct:0.5 ilab serve --model-path  /root/.cache/instructlab/models/instructlab/granite-7b-lab



    ////

    sudo docker network create instructLab

     sudo docker run --rm --runtime=nvidia --gpus all --name serve --network instructLab -p 8000:8000 instruct:0.5 ilab serve --model-path  /root/.cache/instructlab/models/instructlab/granite-7b-lab --backend=vllm -- --host serve

     sudo docker run --rm --runtime=nvidia --gpus all --network instructLab --name chat instruct:0.5 ilab model chat --endpoint-url http://serve:8000/v1 -qq Tell me a story about cheese



sudo docker run --rm --runtime=nvidia --gpus all -v /home/instruct/instructlab:/root/.cache/instructlab quay.io/hayesphilip/instructlab:0.7 ilab init  --non-interactive --model-path /instructlab/granite-7b-lab --taxonomy-path /root/.cache/instructlab/taxonomy

sudo docker run --rm --runtime=nvidia --gpus all -v /home/instruct/instructlab:/root/.cache/instructlab quay.io/hayesphilip/instructlab:0.8 ilab generate --help  

sudo docker run --rm --runtime=nvidia --gpus all -v /home/instruct/instructlab:/root/.cache/instructlab quay.io/hayesphilip/instructlab:0.8 ilab generate  --model /instructlab/granite-7b-lab --taxonomy-path /root/.cache/instructlab/taxonomy --output-dir /root/.cache/instructlab/datasets

sudo docker run  --rm --runtime=nvidia --gpus all -v /home/instruct/instructlab:/root/.cache/instructlab quay.io/hayesphilip/instructlab:0.8 ilab train   --model-path /instructlab/granite-7b-lab --data-path /root/.cache/instructlab/datasets/knowledge_train_msgs_2024-09-18T17_55_26.jsonl --ckpt-output-dir /root/.cache/instructlab/training --device cuda  --gpus 1