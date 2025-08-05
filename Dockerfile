FROM rocm/pytorch:rocm6.4.2_ubuntu22.04_py3.10_pytorch_release_2.6.0

RUN pip install -U pip && pip install wyoming faster-whisper tokenizers
RUN apt-get update && apt-get -y install nano ffmpeg libomp-dev

COPY src /src

WORKDIR /src
RUN git clone https://github.com/arlo-phoenix/CTranslate2-rocm.git --recurse-submodules
RUN ./build.sh

ENTRYPOINT ["/src/run.sh"]
#ENTRYPOINT ["tail", "-f", "/dev/null"]
