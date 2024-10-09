# InstructLab and Granite-7b-lam images

This repository contains the Dockerfile to build container images for the following:

1. InstructLab
Ideal for desktop or Mac users looking to explore InstructLab, this image provides a simple introduction to the platform without requiring specialized hardware. It's perfect for prototyping and testing before scaling up.
2. InstructLab with CUDA Support
Designed for running full training workflows on GPU-equipped Linux servers, this image accelerates the synthetic data generation and training process by leveraging NVIDIA GPUs.
3. Granite-7b-lab
This image is optimized for model serving and inference on desktop or Mac environments, using the Granite-7B model. It allows for efficient and scalable inference tasks without needing a GPU, perfect for smaller-scale deployments or local testing.
4. Granite-7b-lab with CUDA Support
For those with GPU-equipped Linux servers, this image supports faster model inference and serving through CUDA acceleration. This is ideal for high-performance AI applications where response times and throughput are critical.


For instructions on use of these images, vist the following pages:

* [granite-cpu](/granite-cpu.md)
* [granite-cuda](/granite-cuda.md)
* [instructlab-cpu](/instructlab-cpu.md)
* [instructlab-cuda](/instructlab-cuda.md)


