FROM rocm/dev-ubuntu-22.04:6.4.2-complete
# Includes Python 3.10

ARG GFX
ARG WHISPER_MODEL
ENV PYTORCH_ROCM_ARCH=${GFX}
ENV WHISPER_MODEL=${WHISPER_MODEL}

RUN pip install -U pip && pip install wyoming==1.7.2 faster-whisper==1.2.0 tokenizers==0.21.*
RUN apt-get update && apt-get -y install nano ffmpeg libomp-dev git cmake

COPY src /src
WORKDIR /src
RUN chmod +x *.sh

RUN git clone https://github.com/arlo-phoenix/CTranslate2-rocm.git --recurse-submodules
RUN ./build.sh

ENTRYPOINT ["sh", "-c", "/src/run.sh --model ${WHISPER_MODEL}"]
# ENTRYPOINT ["tail", "-f", "/dev/null"]
