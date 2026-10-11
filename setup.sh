#!/bin/bash
# setup.sh — build the docker images, fetch the whisper model and a piper voice.
# Idempotent: whatever is already there is not fetched again. STT_MODEL and TTS_VOICE as in bin/.
set -euo pipefail
cd "$(dirname "$(readlink -f "$0")")"
[ -f voice.env ] && . ./voice.env
docker build -t voice-whisper docker-whisper
docker build -t voice-piper docker-piper

fetch() { [ -s "$2" ] || { curl -fL --progress-bar -o "$2.part" "$1" && mv "$2.part" "$2"; }; }

m=ggml-${STT_MODEL:-small}.bin
mkdir -p models piper-voices
fetch "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/$m" "models/$m"

# it_IT-paola-medium -> it/it_IT/paola/medium/
v=${TTS_VOICE:-it_IT-paola-medium}
IFS=- read -r loc name q <<<"$v"
base="https://huggingface.co/rhasspy/piper-voices/resolve/main/${loc%%_*}/$loc/$name/$q/$v"
fetch "$base.onnx" "piper-voices/$v.onnx"
fetch "$base.onnx.json" "piper-voices/$v.onnx.json"
