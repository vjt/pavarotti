# .voice — vocali in locale per bot Telegram

Trascrizione (whisper.cpp) e sintesi (piper) in docker, tutto sulla macchina: nessun
servizio esterno, e sull'host non entra codice di terzi. Pensato per un Raspberry Pi 5:
mezzo minuto di vocale si trascrive in 10-15 s col modello small, una risposta si sintetizza
in ~5 s.

```
./setup.sh                          # immagini docker + modello whisper + voce piper
bin/stt vocale.oga                  # testo su stdout
bin/tts risposta.ogg < testo.txt    # OGG/Opus, il formato dei vocali Telegram
bin/tg-voice get <file_id>          # scarica un vocale dalla Bot API e lo trascrive
bin/tg-voice send <chat_id> r.ogg   # lo manda come vocale
```

Impostazioni da variabili d'ambiente, o da un `voice.env` accanto a questo file (fuori dal
repo, lo leggono tutti gli script):

| variabile | default | |
|---|---|---|
| `STT_LANG` | `it` | lingua per whisper |
| `STT_MODEL` | `small` | `models/ggml-$STT_MODEL.bin` |
| `STT_THREADS` | `4` | |
| `TTS_VOICE` | `it_IT-paola-medium` | `piper-voices/$TTS_VOICE.onnx`, catalogo su [rhasspy/piper-voices](https://huggingface.co/rhasspy/piper-voices) |
| `TG_TOKEN_FILE` | — | file con il solo token del bot, per `tg-voice` |

`skill/SKILL.md` e' la skill per Claude Code: linkala in `.claude/skills/voice/` del
progetto del bot.

Se un `docker image prune` si porta via le immagini, `./setup.sh` le ricostruisce; modelli
e voci gia' scaricati restano.
