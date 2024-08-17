# Wyoming Faster Whisper ROCm

## Quick Description
Faster whisper Running on AMD GPUs with modified CTranslate 2 Libraries served up with Wyoming protocol


## System Overview

This project ties together a few projects to make Faster Whisper work with an AMD GPU. This has only been built for an AMD APU (5650G) at this time.

### Host System & Hardware Requirements
- AMD GPU or APU with an architecture `gfx900` or newer
	- - Check you architecture [here](https://llvm.org/docs/AMDGPUUsage.html) if you don't know
- At least 100gb of disk space.
- [ROCm Installed ](https://rocm.docs.amd.com/projects/install-on-linux/en/latest/index.html)
- [Docker Installed](https://docs.docker.com/desktop/install/linux-install/)
- [Docker Compose Plugin Installed](https://docs.docker.com/compose/install/linux/)
### Services Required to Use this Service
- [HomeAssistant](https://www.home-assistant.io/)
	- [Wyoming Addon](https://www.home-assistant.io/integrations/wyoming/)

### Tools to Make your Life Easier
- [btop](https://github.com/aristocratos/btop)
	- Great for CPU and Memory Monitoring
- [AMDGPU_TOP](https://github.com/Umio-Yasuno/amdgpu_top)
	- Excellent Command Line Utility for Viewing GPU utilization. 

## Project Components

- [Wyoming](https://pypi.org/project/wyoming/)
- [Faster Whisper](https://pypi.org/project/faster-whisper/)
- [ROCm/Pytorch](https://hub.docker.com/r/rocm/pytorch)
	- Build Requires Python 3.9, the project makes use of the 20.04 image.
- [CTranslate2-rocm](https://github.com/arlo-phoenix/CTranslate2-rocm)
	- This project is essential to running Faster Whisper as the standard CTranslate2 Library does not support ROCm natively. 
	- This project needs to be built to the GPU architecture specific to your hardware.

**Note:** The docker image required for this project is massive. On my system it is showing as 68g.4b.


## Instructions:

1. Clone this repository and open the directory

```bash
git clone https://github.com/Donkey545/wyoming-faster-whisper-rocm.git
cd wyoming-faster-whisper-rocm/
```

2. Modify the `docker-compose.yml` to reflect your GPU architecture
	1. Get your architecture:

```bash
rocminfo |grep " gfx"
...
# The Response should look something like:
#  Name:                    gfx90c
```
	2. Modify the environment section

```yaml
version: "3"

services:
  whisper:
    container_name: faster-whisper-rocm
    restart: unless-stopped
    build:
      context: .
    volumes:
      - ./data:/data
    ports:
      - "10300:10300"
    devices:
      - "/dev/dri"
      - "/dev/kfd"
    environment:
      - HSA_OVERRIDE_GFX_VERSION=9.0.0 #This line can be removed if newer than VEGA
```
3. Run Docker Compose
``` bash
docker compose up -d --build
```
At this point you can configure the Whisper service with Wyoming in home assistant with the `<dockerhost_ip_address>:10300`.

### Optional Manual Build
In the docker file, comment out the build script line, and chand the entrypoint command to `#ENTRYPOINT ["tail", "-f", "/dev/null"]`. Exporting the Pytorch ROCm Arch as an environment variable will restrict the scope of the build to your specific architecture. This caused some problems for me on my APU, so the support may vary.  Refer to the instruction on the ROCm Installation for [CTranslate2-rocm](https://github.com/arlo-phoenix/CTranslate2-rocm). 

3o. Run Docker Compose and Open an Interactive Terminal
``` bash
docker compose up -d --build
...
docker exec -it faster-whisper-rocm  bash
```

4o. Run the build script. This will take several minutes as it is building all of the graphic architecture versions. You can scope this down with an optional environment variable.
``` bash
#export PYTORCH_ROCM_ARCH=gfx1030 #optional
./src/build.sh
```
5o. Start the service:
``` bash
./run.sh
# you can send this to background and run detached to have it operate as normal now.
# nohup run.sh  &

```
