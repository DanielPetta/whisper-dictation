# Whisper Dictation

A local, system-wide speech-to-text tool for macOS using OpenAI's Whisper model. Press a keyboard shortcut, speak, and your words are typed into whatever app you're using. No cloud, no subscription, fully private.

## Two Modes

- **Raw mode** (`dictate.sh`) — Types exactly what you said
- **Clean mode** (`dictate-clean.sh`) — Cleans up your speech (removes filler words, fixes grammar) using a local AI model before typing

## How It Works

1. Press the keyboard shortcut → hear a **Tink** sound (recording started)
2. Speak into your mic
3. Recording stops when:
   - You press the shortcut again → **Pop** sound
   - 7 seconds of silence → **Pop** sound
   - 30-second maximum reached → **Funk** sound
4. Your speech is transcribed and typed into the active text field

In all cases, your audio is transcribed — nothing is lost.

## Requirements

- Apple Silicon Mac (recommended) or Intel Mac
- macOS 13+
- [Homebrew](https://brew.sh) installed

## Install

```bash
git clone https://github.com/DanielPetta/whisper-dictation.git
cd whisper-dictation
chmod +x setup.sh
./setup.sh
```

The setup script installs:
- `whisper-cpp` — local speech-to-text engine
- `sox` — audio recording
- `ollama` + `gemma3:4b` — local AI model for clean mode
- Whisper `base.en` model (~150MB download)

## Setting Up Keyboard Shortcuts

After running the setup script, create two shortcuts in the macOS **Shortcuts** app:

### Raw Dictation (Control + `)

1. Open **Shortcuts**
2. Create a new shortcut
3. Add action: **Run Shell Script**
4. Set shell to `/bin/zsh`
5. Set the script to: `~/dictate.sh`
6. Click the **ⓘ** button
7. Enable **Use as Quick Action**
8. Assign keyboard shortcut: **Control + `**

### Clean Dictation (Control + Shift + `)

1. Repeat the above steps but:
   - Set the script to: `~/dictate-clean.sh`
   - Assign keyboard shortcut: **Control + Shift + `**

## Permissions

macOS requires you to grant permissions the first time. Go to **System Settings → Privacy & Security** and enable:

- **Accessibility**: Terminal, Shortcuts
- **Microphone**: Terminal, Shortcuts

macOS should prompt you automatically on first use — just click Allow.

## Updating

If the scripts are updated:

```bash
cd whisper-dictation
git pull
./setup.sh
```

## Sounds

| Event | Sound | Meaning |
|-------|-------|---------|
| Recording starts | Tink | You can start speaking |
| Recording stops (manual or silence) | Pop | Transcription is being typed |
| 30-second max reached | Funk | Time's up, but audio is still transcribed |

To change sounds, edit the `SOUND_START`, `SOUND_DONE`, and `SOUND_TIMEOUT` variables in the scripts. Available sounds are in `/System/Library/Sounds/`.

## Troubleshooting

**Recording gets stuck:**
```bash
pkill sox
rm -f /tmp/dictate_pid /tmp/dictate_clean_pid
```

**Text doesn't type into apps:**
Check Accessibility permissions in System Settings.

**Microphone not working:**
Check Microphone permissions in System Settings.

**Clean mode is slow or not working:**
Make sure Ollama is running: `ollama serve` (it usually starts automatically). You can test it with: `ollama run gemma3:4b "Hello"`

## Customization

- **Change silence timeout**: Edit `7.0` in the `sox` command (e.g., `5.0` for 5 seconds)
- **Change max duration**: Edit `MAX_DURATION=30` (in seconds)
- **Change AI model**: Edit `OLLAMA_MODEL` in `dictate-clean.sh` (e.g., `phi4-mini` for a different model)
- **Change sounds**: Edit the `SOUND_*` variables (run `ls /System/Library/Sounds/` to see options)
