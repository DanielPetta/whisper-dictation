#!/bin/bash

# Whisper Dictation — Setup Script
# Installs dependencies and places scripts for macOS

set -e

echo "========================================"
echo "  Whisper Dictation — Setup"
echo "========================================"
echo ""

# Check for Homebrew
if ! command -v brew &>/dev/null; then
    echo "❌ Homebrew not found. Install it first:"
    echo '   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
    exit 1
fi

echo "✅ Homebrew found"

# Install whisper-cpp
if command -v whisper-cli &>/dev/null; then
    echo "✅ whisper-cpp already installed"
else
    echo "📦 Installing whisper-cpp..."
    brew install whisper-cpp
fi

# Install sox
if command -v sox &>/dev/null; then
    echo "✅ sox already installed"
else
    echo "📦 Installing sox..."
    brew install sox
fi

# Download Whisper model
MODELS_DIR=~/whisper-models
MODEL_FILE="$MODELS_DIR/ggml-base.en.bin"

if [ -f "$MODEL_FILE" ]; then
    echo "✅ Whisper model already downloaded"
else
    echo "📦 Downloading Whisper model (base.en)..."
    mkdir -p "$MODELS_DIR"
    curl -L -o "$MODEL_FILE" \
        "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-base.en.bin"
fi

# Get the directory where this script lives
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Copy scripts to home directory
echo "📦 Installing dictation scripts..."
cp "$SCRIPT_DIR/dictate.sh" ~/dictate.sh
cp "$SCRIPT_DIR/dictate-clipboard.sh" ~/dictate-clipboard.sh
chmod +x ~/dictate.sh
chmod +x ~/dictate-clipboard.sh

echo ""
echo "========================================"
echo "  ✅ Installation Complete!"
echo "========================================"
echo ""
echo "Scripts installed to:"
echo "  ~/dictate.sh            (raw mode — types exactly what you say)"
echo "  ~/dictate-clipboard.sh  (clipboard mode — for use with Apple Intelligence)"
echo ""
echo "NEXT STEPS — Create two macOS Shortcuts:"
echo ""
echo "  SHORTCUT 1: Raw Dictation"
echo "  ─────────────────────────"
echo "  1. Open the Shortcuts app"
echo "  2. Create a new shortcut"
echo "  3. Add action: 'Run Shell Script'"
echo "  4. Set shell to: /bin/zsh"
echo "  5. Script: /Users/$(whoami)/dictate.sh"
echo "  6. Click ⓘ → Enable 'Use as Quick Action'"
echo "  7. Assign keyboard shortcut: Control + \`"
echo ""
echo "  SHORTCUT 2: Clean Dictation (with Apple Intelligence)"
echo "  ─────────────────────────────────────────────────────"
echo "  1. Create a new shortcut"
echo "  2. Add action: 'Run Shell Script'"
echo "  3. Set shell to: /bin/zsh"
echo "  4. Script: /Users/$(whoami)/dictate-clipboard.sh"
echo "  5. Add action: 'Get Clipboard'"
echo "  6. Add action: 'Use Model' → select 'On-Device'"
echo "  7. Set the prompt to:"
echo "     Clean up this spoken text. Fix grammar, remove filler"
echo "     words, and make it concise. Do not change the meaning."
echo "     Return only the cleaned text."
echo "  8. Add action: 'Copy to Clipboard'"
echo "  9. Add action: 'Paste'"
echo "  10. Click ⓘ → Enable 'Use as Quick Action'"
echo "  11. Assign a keyboard shortcut (e.g., F6)"
echo ""
echo "  PERMISSIONS (one-time):"
echo "  System Settings → Privacy & Security"
echo "  • Accessibility: Terminal, Shortcuts"
echo "  • Microphone: Terminal, Shortcuts"
echo ""
