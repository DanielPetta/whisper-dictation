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

It also copies two scripts to your home directory:
- `/Users/YOUR_USERNAME/dictate.sh`
- `/Users/YOUR_USERNAME/dictate-clipboard.sh`

## Setting Up Keyboard Shortcuts

After running the setup script, you need to create shortcuts in the macOS **Shortcuts** app. The scripts are installed to your home directory but won't show up in Finder — you'll type the path directly into the Shortcuts app.

### Shortcut 1: Raw Dictation

1. Open the **Shortcuts** app
2. Click **+** to create a new shortcut
3. Name it something like **Whisper Raw**
4. In the search bar on the right, search for **Run Shell Script** and add it
5. In the script text box, type: `/Users/YOUR_USERNAME/dictate.sh`
   - Replace `YOUR_USERNAME` with your Mac username (e.g., `danielpetta`)
   - The full path should look like: `/Users/danielpetta/dictate.sh`
6. Set **Shell** to: `zsh`
7. Leave Input, Pass Input, and Run as Administrator at their defaults
8. Click the **ⓘ** (info) button at the top of the shortcut
9. Enable **Use as Quick Action**
10. Click **Add Keyboard Shortcut** and press **Control + `** (the backtick key, above Tab)

### Shortcut 2: Clean Dictation (with Apple Intelligence)

This shortcut records your speech, transcribes it, then uses Apple Intelligence to clean up the text before pasting it.

1. Click **+** to create a new shortcut
2. Name it something like **Whisper Clean**
3. Add these actions in order:

**Action 1 — Run Shell Script:**
- Search for **Run Shell Script** and add it
- In the script text box, type: `/Users/YOUR_USERNAME/dictate-clipboard.sh`
  - Replace `YOUR_USERNAME` with your Mac username
- Set **Shell** to: `zsh`

**Action 2 — Get Clipboard:**
- Search for **Get Clipboard** and add it

**Action 3 — Use Model:**
- Search for **Use Model** and add it
- Select **On-Device** (keeps everything local and private) or **Private Cloud Compute** (uses Apple's cloud)
- In the prompt text box, type: `Clean up this spoken text. Fix grammar, remove filler words, and make it concise. Do not change the meaning. Return only the cleaned text.`

**Action 4 — Copy to Clipboard:**
- Search for **Copy to Clipboard** and add it
- Make sure it's set to copy the **Response** from the Use Model step

**Action 5 — Type the Result:**
- Add another **Run Shell Script** action
- In the script text box, type: `osascript -e 'tell application "System Events" to keystroke (the clipboard)'`
- Set **Shell** to: `zsh`

4. Click the **ⓘ** (info) button at the top of the shortcut
5. Enable **Use as Quick Action**
6. Click **Add Keyboard Shortcut** and press your preferred key (e.g., **F6**)

> **Note:** If Control + Shift + ` doesn't work as a shortcut, use a function key like F6 instead. Some key combinations don't register in macOS Shortcuts.

## Permissions

macOS requires you to grant permissions the first time. Go to **System Settings → Privacy & Security** and enable:

- **Accessibility**: Terminal, Shortcuts
- **Microphone**: Terminal, Shortcuts

macOS should prompt you automatically on first use — just click Allow.

## Testing

You can test the scripts directly from Terminal before setting up Shortcuts:

**Test raw mode:**
1. Open Notes (or any app with a text field) and click into it
2. In Terminal, run: `~/dictate.sh`
3. Speak a sentence, then either wait 7 seconds or open another Terminal tab and run `~/dictate.sh` again to stop
4. The transcribed text should appear in your text field

**Test clipboard mode:**
1. In Terminal, run: `~/dictate-clipboard.sh`
2. Speak a sentence, then wait for it to finish
3. Open any text field and press Command + V — your transcribed text should paste

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

To change sounds, edit the `SOUND_START`, `SOUND_DONE`, and `SOUND_TIMEOUT` variables in the scripts. Run `ls /System/Library/Sounds/` in Terminal to preview available sounds. You can listen to any sound with `afplay /System/Library/Sounds/Pop.aiff`.

## Troubleshooting

**Recording gets stuck:**
```bash
pkill sox
rm -f /tmp/dictate_pid /tmp/dictate_clipboard_pid
```

**Text doesn't type into apps:**
Check Accessibility permissions in System Settings → Privacy & Security → Accessibility. Make sure both Terminal and Shortcuts are listed and enabled.

**Microphone not working:**
Check Microphone permissions in System Settings → Privacy & Security → Microphone.

**"No such file or directory" error in Shortcuts:**
Make sure you've run `./setup.sh` first — this copies the scripts to your home directory. The path in the shortcut should be the full path, e.g., `/Users/danielpetta/dictate.sh` (not `~/dictate.sh`).

**Clean mode shortcut not triggering:**
Some key combinations don't work in macOS Shortcuts. Try using a function key (F5, F6, etc.) instead of modifier key combos.

**Clean mode not cleaning up text:**
Make sure Apple Intelligence is enabled in System Settings → Apple Intelligence & Siri. Check that the Shortcut has all the actions in the right order: Run Shell Script → Get Clipboard → Use Model → Copy to Clipboard → Run Shell Script (paste).

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

Then delete the shortcuts from the Shortcuts app.
