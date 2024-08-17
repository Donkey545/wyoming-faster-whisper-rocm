#!/usr/bin/env bash

conda init bash
source activate py_3.9
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CONDA_PREFIX/lib/
export HSA_OVERRIDE_GFX_VERSION=9.0.0
exec python3 -m wyoming_whisper --device cuda --model distil-small.en --uri 'tcp://0.0.0.0:10300' --data-dir /data --download-dir /data "$@"