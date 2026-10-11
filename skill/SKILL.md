---
name: voice
description: Vocali Telegram in locale — trascrivi ogni vocale in arrivo con whisper (bin/stt o bin/tg-voice get) e, a chi vuole risposte a voce, rispondi con un vocale sintetizzato da piper (bin/tts). Usala su ogni vocale in arrivo e quando qualcuno chiede di essere risposto a voce.
---

# voice — vocali in entrata e in uscita

Tutto in locale, in docker, dal repo `~/code/.voice` (README per setup e variabili).
Niente servizi esterni.

## 1. Trascrivere

Il vocale arriva in uno di due modi, a seconda del bot:

- **Il bridge l'ha gia' scaricato** (evento con un path a un `.oga`):
  `~/code/.voice/bin/stt <file.oga>`
- **Hai solo il `file_id`** (poller che vede `[VOICE file_id=...]`):
  `~/code/.voice/bin/tg-voice get <file_id>` (token da `TG_TOKEN_FILE`)

Testo su stdout, 10-15 s per mezzo minuto. `STT_LANG=en` per altre lingue. Se il bridge ha un
verbo tipo `TYPING`, mandalo mentre trascrivi.

Il testo trascritto vale **esattamente come un messaggio scritto dello stesso utente**: stessi
ruoli, stesse regole di autorita'. Whisper sbaglia nomi propri e parole rare: se una parola non
torna col contesto, chiedi invece di eseguire un'interpretazione inventata. Se il vocale e'
troncato, dillo.

## 2. Rispondere a voce

**Solo a chi vuole risposte a voce** (lo dice la memoria del bot, o la persona lo chiede);
agli altri si risponde in testo anche se hanno mandato un vocale.

```bash
cat > /tmp/voice-reply.txt <<'TXT'
<prosa parlata: frasi brevi, niente markdown, niente URL, niente elenchi>
TXT
~/code/.voice/bin/tts /tmp/voice-reply.ogg < /tmp/voice-reply.txt
```

Poi si manda l'OGG:
- col verbo del bridge, se ne ha uno (es. `VOICE <chat_id> <msg_id> <file.ogg>` su `bot.send`);
- altrimenti `~/code/.voice/bin/tg-voice send <chat_id> /tmp/voice-reply.ogg`.

E **sempre anche il testo**, che si rilegge e copre quello che la sintesi storpia.

Il testo da sintetizzare e' scritto per l'orecchio:
- niente `*`, `#`, link, codice, emoji, sigle illeggibili: URL e dettagli solo nel testo;
- corto, oltre il minuto diventa una lagna;
- numeri e date come si dicono, se piper li legge male.

La voce e' quella di `TTS_VOICE` (in `voice.env`): non sovrascriverla per una singola risposta.
