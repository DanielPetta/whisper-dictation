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

# Install Ollama (for clean mode)
if command -v ollama &>/dev/null; then
    echo "✅ Ollama already installed"
else
    echo "📦 Installing Ollama..."
    brew install ollama
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

# Pull Gemma model for Ollama
echo "📦 Pulling Gemma model for clean mode (this may take a few minutes)..."
ollama pull gemma3:4b

# Get the directory where this script lives
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Copy scripts to home directory
echo "📦 Installing dictation scripts..."
cp "$SCRIPT_DIR/dictate.sh" ~/dictate.sh
cp "$SCRIPT_DIR/dictate-clean.sh" ~/dictate-clean.sh
chmod +x ~/dictate.sh
chmod +x ~/dictate-clean.sh

echo ""
echo "========================================"
echo "  ✅ Installation Complete!"
echo "========================================"
echo ""
echo "Scripts installed to:"
echo "  ~/dictate.sh        (raw mode)"
echo "  ~/dictate-clean.sh  (clean mode)"
echo ""
echo "NEXT STEPS — Create two macOS Shortcuts:"
echo ""
echo "1. Open the Shortcuts app"
echo "2. Create a new shortcut for RAW dictation:"
echo "   • Add action: 'Run Shell Script'"
echo "   • Set shell to: /bin/zsh"
echo "   • Script: ~/dictate.sh"
echo "   • Click ⓘ → Enable 'Use as Quick Action'"
echo "   • Assign keyboard shortcut: Control + \`"
echo ""
echo "3. Create a new shortcut for CLEAN dictation:"
echo "   • Add action: 'Run Shell Script'"
echo "   • Set shell to: /bin/zsh"
echo "   • Script: ~/dictate-clean.sh"
echo "   • Click ⓘ → Enable 'Use as Quick Action'"
echo "   • Assign keyboard shortcut: Control + Shift + \`"
echo ""
echo "4. Grant permissions (System Settings → Privacy & Security):"
echo "   • Accessibility: Terminal, Shortcuts"
echo "   • Microphone: Terminal, Shortcuts"
echo ""
echo "5. Test it! Click into any text field and press Control + \`"
echo ""
