# instructlab-image

Install nvidia drivers

sudo dnf install kernel-devel-$(uname -r) kernel-headers-$(uname -r)

sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm

sudo dnf config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/$distro/$arch/cuda-$distro.repo

sudo dnf config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/$distro/$arch/cuda-$distro.repo

sudo dnf clean expire-cache

sudo dnf module install nvidia-driver:open-dkms


// Install nvidia container toolkit
curl -s -L https://nvidia.github.io/libnvidia-container/stable/rpm/nvidia-container-toolkit.repo | \
  sudo tee /etc/yum.repos.d/nvidia-container-toolkit.repo

  sudo dnf install -y nvidia-container-toolkit

  sudo nvidia-ctk runtime configure --runtime=docker

  sudo systemctl restart docker

  sudo docker run --rm --runtime=nvidia --gpus all instruct  tail -f /dev/null