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

  sudo systemctl restart docker


# Running the container


  sudo docker run --rm --runtime=nvidia --gpus all nvidia/cuda:12.2.2-devel-ubi9  tail -f /dev/null

    sudo docker run --rm --runtime=nvidia --gpus all instruct:0.5 ilab serve --model-path  /root/.cache/instructlab/models/instructlab/granite-7b-lab



    ////

    sudo docker network create instructLab

     sudo docker run --rm --runtime=nvidia --gpus all --name serve --network instructLab -p 8000:8000 quay.io/hayesphilip/instructlab:0.8  ilab serve --model-path  /instructlab/granite-7b-lab --backend=vllm -- --host serve

     sudo docker run --rm --runtime=nvidia --gpus all --network instructLab --name chat quay.io/hayesphilip/instructlab:0.8  ilab model chat --endpoint-url http://serve:8000/v1 -qq Tell me a story about cars



sudo docker run --rm --runtime=nvidia --gpus all -v /home/instruct/instructlab:/root/.cache/instructlab quay.io/hayesphilip/instructlab:0.8 ilab init  --non-interactive --model-path /instructlab/granite-7b-lab --taxonomy-path /root/.cache/instructlab/taxonomy 

sudo chown -R instruct taxonomy/

sudo docker run --rm --runtime=nvidia --gpus all --ipc=host -v /home/instruct/instructlab:/instructlab/share quay.io/hayesphilip/instructlab:0.11 ilab generate  --model /instructlab/granite-7b-lab --taxonomy-path /instructlab/share/taxonomy --output-dir /root/.cache/instructlab/datasets --gpus 4

sudo docker run  --rm --runtime=nvidia --gpus all --ipc=host  -v /home/instruct/instructlab:/instructlab/share quay.io/hayesphilip/instructlab:0.11 ilab train   --model-path /instructlab/granite-7b-lab --data-path /root/.cache/instructlab/datasets/knowledge_train_msgs_2024-09-19T00_07_35.jsonl --ckpt-output-dir /root/.cache/instructlab/training --device cuda  --gpus 4


sudo docker run  --rm --runtime=nvidia --gpus all --ipc=host  -v /home/instruct/instructlab:/root/.cache/instructlab quay.io/hayesphilip/instructlab:0.11 ilab train   --model-path /instructlab/granite-7b-lab --data-path /root/.cache/instructlab/datasets/knowledge_train_msgs_2024-09-19T00_07_35.jsonl --ckpt-output-dir /root/.cache/instructlab/training --gpus 4 --device cuda   --deepspeed-cpu-offload-optimizer true --deepspeed-cpu-offload-optimizer-pin-memory true --effective-batch-size 32  --is-padding-free true  --lora-quantize-dtype null --lora-rank 0



https://github.com/instructlab/taxonomy.git




sudo docker run --rm --runtime=nvidia --gpus all --ipc=host -v /home/instruct/instructlab:/instructlab/share quay.io/hayesphilip/instructlab:0.15 ilab generate --model /instructlab/models/instructlab/granite-7b-lab  --gpus 4 --output-dir /instructlab/share/datasets

sudo docker run  --rm --runtime=nvidia --gpus all --ipc=host  -v /home/instruct/instructlab:/instructlab/share quay.io/hayesphilip/instructlab:0.15 ilab train --gpus 4 --data-path /instructlab/share/datasets/knowledge_train_msgs_2024-09-20T14_51_48.jsonl