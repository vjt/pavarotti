# pavarotti — local voice notes for Telegram bots

Speech-to-text (whisper.cpp) and text-to-speech (piper) in docker, all on the machine: no
external services, and no third-party code on the host. Built for a Raspberry Pi 5: half a
minute of voice note transcribes in 10-15 s with the small model, a reply synthesizes in ~5 s.

```
./setup.sh                          # docker images + whisper model + piper voice
bin/stt note.oga                    # text on stdout
bin/tts reply.ogg < text.txt        # OGG/Opus, the Telegram voice-note format
bin/tg-voice get <file_id>          # download a voice note from the Bot API and transcribe it
bin/tg-voice send <chat_id> r.ogg   # send it as a voice note
```

Settings come from environment variables, or from a `voice.env` next to this file (kept out
of the repo, every script reads it):

| variable | default | |
|---|---|---|
| `STT_LANG` | `it` | whisper language |
| `STT_MODEL` | `small` | `models/ggml-$STT_MODEL.bin` |
| `STT_THREADS` | `4` | |
| `TTS_VOICE` | `it_IT-paola-medium` | `piper-voices/$TTS_VOICE.onnx`, catalog at [rhasspy/piper-voices](https://huggingface.co/rhasspy/piper-voices) |
| `TG_TOKEN_FILE` | — | file holding only the bot token, for `tg-voice` |

`skill/SKILL.md` is the Claude Code skill: link it into `.claude/skills/voice/` of the bot's
project.

`setup.sh` also creates a stopped container per image (`voice-whisper-pin`, `voice-piper-pin`)
so that `docker image prune -a` leaves the images alone. If they go anyway, `./setup.sh`
rebuilds them; models and voices already downloaded stay.
