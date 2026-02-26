# Whisper Dictation

A local, system-wide speech-to-text tool for macOS using OpenAI's Whisper model. Press a keyboard shortcut, speak, and your words are typed into whatever app you're using. No cloud, no subscription, fully private.

## Two Modes

- **Raw mode** (`dictate.sh`) — Types exactly what you said, no changes
- **Clean mode** (`dictate-clipboard.sh` + Apple Intelligence) — Cleans up your speech (removes filler words, fixes grammar, makes it concise) using Apple Intelligence before pasting

## How It Works

1. Press the keyboard shortcut → hear a **Tink** sound (recording started)
2. Speak into your mic
3. Recording stops when:
   - You press the shortcut again → **Pop** sound
   - 7 seconds of silence → **Pop** sound
   - 30-second maximum reached → **Funk** sound
4. Your speech is transcribed and either typed directly (raw) or cleaned up first (clean)

In all cases, your audio is transcribed — nothing is lost.

## Requirements

- Apple Silicon Mac (M1 or later)
- macOS Tahoe 26+ with Apple Intelligence enabled (for clean mode)
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
- Whisper `base.en` model (~150MB download)

## Setting Up Keyboard Shortcuts

After running the setup script, create two shortcuts in the macOS **Shortcuts** app.

### Shortcut 1: Raw Dictation

1. Open **Shortcuts** and create a new shortcut
2. Add action: **Run Shell Script**
3. Set shell to `/bin/zsh`
4. Set the script to: `/Users/YOUR_USERNAME/dictate.sh`
5. Click the **ⓘ** button → Enable **Use as Quick Action**
6. Assign keyboard shortcut: **Control + `**

### Shortcut 2: Clean Dictation (with Apple Intelligence)

1. Create a new shortcut
2. Add action: **Run Shell Script**
   - Set shell to `/bin/zsh`
   - Script: `/Users/YOUR_USERNAME/dictate-clipboard.sh`
3. Add action: **Get Clipboard**
4. Add action: **Use Model** → select **On-Device**
   - Set the prompt to: `Clean up this spoken text. Fix grammar, remove filler words, and make it concise. Do not change the meaning. Return only the cleaned text.`
5. Add action: **Copy to Clipboard**
6. Add action: **Paste**
7. Click the **ⓘ** button → Enable **Use as Quick Action**
8. Assign a keyboard shortcut (e.g., **F6**)

## Permissions

macOS requires you to grant permissions the first time. Go to **System Settings → Privacy & Security** and enable:

- **Accessibility**: Terminal, Shortcuts
- **Microphone**: Terminal, Shortcuts

macOS should prompt you automatically on first use — just click Allow.

## Updating

If the scripts are updated:

```bash
cd ~/whisper-dictation
git pull
./setup.sh
```

## Sounds

| Event | Sound | Meaning |
|-------|-------|---------|
| Recording starts | Tink | You can start speaking |
| Recording stops (manual or silence) | Pop | Transcription complete |
| 30-second max reached | Funk | Time's up, but audio is still transcribed |

To change sounds, edit the `SOUND_START`, `SOUND_DONE`, and `SOUND_TIMEOUT` variables in the scripts. Run `ls /System/Library/Sounds/` in Terminal to see all available sounds.

## Troubleshooting

**Recording gets stuck:**
```bash
pkill sox
rm -f /tmp/dictate_pid /tmp/dictate_clipboard_pid
```

**Text doesn't type into apps:**
Check Accessibility permissions in System Settings.

**Microphone not working:**
Check Microphone permissions in System Settings.

**Clean mode not working:**
Make sure Apple Intelligence is enabled in System Settings → Apple Intelligence & Siri. Check that the Shortcut has all the actions in the right order (Run Shell Script → Get Clipboard → Use Model → Copy to Clipboard → Paste).

## Customization

- **Change silence timeout**: Edit `7.0` in the `sox` command (e.g., `5.0` for 5 seconds)
- **Change max duration**: Edit `MAX_DURATION=30` (in seconds)
- **Change sounds**: Edit the `SOUND_*` variables (run `ls /System/Library/Sounds/` to preview options)
- **Change Whisper model**: Download a different model to `~/whisper-models/` and update the `MODEL` variable
  - `tiny.en` — fastest, least accurate
  - `base.en` — good balance (default)
  - `small.en` — slower, more accurate

## Uninstalling

To remove everything:

```bash
rm ~/dictate.sh ~/dictate-clipboard.sh
rm -rf ~/whisper-models
rm -rf ~/whisper-dictation
brew uninstall whisper-cpp sox
```

Then delete the two Shortcuts from the Shortcuts app.
