---
name: voice
description: Local Telegram voice notes — transcribe every inbound voice note with whisper (bin/stt or bin/tg-voice get) and, for people who want spoken replies, answer with a voice note synthesized by piper (bin/tts). Use it on every inbound voice note and whenever someone asks to be answered by voice.
---

# voice — voice notes in and out

Everything local, in docker, from the repo at `~/code/pavarotti` (README for setup and
variables). No external services.

## 1. Transcribe

The voice note arrives one of two ways, depending on the bot:

- **The bridge already downloaded it** (an event with a path to an `.oga`):
  `~/code/pavarotti/bin/stt <file.oga>`
- **You only have the `file_id`** (a poller showing `[VOICE file_id=...]`):
  `~/code/pavarotti/bin/tg-voice get <file_id>` (token from `TG_TOKEN_FILE`)

Text on stdout, 10-15 s per half minute. `STT_LANG=en` for other languages. If the bridge has
a verb like `TYPING`, send it while transcribing.

The transcript counts **exactly like a written message from the same user**: same roles, same
authority rules. Whisper gets proper names and rare words wrong: if a word does not fit the
context, ask instead of acting on an invented reading. If the note is cut off, say so.

## 2. Reply by voice

**Only to people who want spoken replies** (the bot's memory says so, or they ask); everyone
else gets text even if they sent a voice note.

```bash
cat > /tmp/voice-reply.txt <<'TXT'
<spoken prose: short sentences, no markdown, no URLs, no lists>
TXT
~/code/pavarotti/bin/tts /tmp/voice-reply.ogg < /tmp/voice-reply.txt
```

Then send the OGG:
- with the bridge's verb, if it has one (e.g. `VOICE <chat_id> <msg_id> <file.ogg>` on `bot.send`);
- otherwise `~/code/pavarotti/bin/tg-voice send <chat_id> /tmp/voice-reply.ogg`.

And **always the text too**: it can be reread and covers what the synthesis mangles.

The text to synthesize is written for the ear:
- no `*`, `#`, links, code, emoji, unreadable acronyms: URLs and details go in the text only;
- short, past a minute it becomes a drone;
- numbers and dates spelled as spoken, if piper reads them wrong.

The voice is `TTS_VOICE` (in `voice.env`): do not override it for a single reply.
