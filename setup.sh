#!/bin/bash
# setup.sh — costruisce le immagini docker e scarica il modello whisper e una voce piper.
# Idempotente: quello che c'e' gia' non si riscarica. STT_MODEL e TTS_VOICE come in bin/.
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
