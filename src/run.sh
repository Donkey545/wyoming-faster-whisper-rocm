#!/usr/bin/env bash

# conda init bash
# source ~/.bashrc
# conda activate py_3.10

# export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CONDA_PREFIX/lib/
# export HSA_OVERRIDE_GFX_VERSION=9.0.0
exec python3 -m wyoming_whisper --device cuda --uri 'tcp://0.0.0.0:10300' --data-dir /data --download-dir /data "$@"
