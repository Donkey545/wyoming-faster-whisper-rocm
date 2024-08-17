FROM rocm/pytorch:rocm6.2_ubuntu20.04_py3.9_pytorch_release_2.3.0

RUN pip install -U pip && pip install wyoming==1.6.0 faster-whisper==1.0.3 tokenizers==0.13.*
RUN apt-get update && apt-get -y install nano ffmpeg libomp-dev

COPY src /src

WORKDIR /src
RUN git clone https://github.com/arlo-phoenix/CTranslate2-rocm.git --recurse-submodules
RUN ./build.sh

ENTRYPOINT ["/src/run.sh"]
#ENTRYPOINT ["tail", "-f", "/dev/null"]
