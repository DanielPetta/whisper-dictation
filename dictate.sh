#!/bin/bash

# Whisper Dictation — Raw Mode
# Transcribes speech exactly as spoken and types it into the active app
# Stop: press shortcut again, 7s silence, or 30s max

MODEL=~/whisper-models/ggml-base.en.bin
AUDIO=/tmp/dictate_input.wav
OUTPUT_PREFIX=/tmp/dictate_output
PID_FILE=/tmp/dictate_pid

SOUND_START="/System/Library/Sounds/Tink.aiff"
SOUND_DONE="/System/Library/Sounds/Pop.aiff"
SOUND_TIMEOUT="/System/Library/Sounds/Funk.aiff"

MAX_DURATION=30

stop_and_transcribe() {
    local timed_out=$1
    rm -f "$PID_FILE"

    whisper-cli -m "$MODEL" -f "$AUDIO" -otxt -of "$OUTPUT_PREFIX" >/dev/null 2>&1

    TEXT=$(cat "$OUTPUT_PREFIX.txt")

    osascript -e "tell application \"System Events\" to keystroke \"$TEXT\""

    if [ "$timed_out" = "true" ]; then
        afplay "$SOUND_TIMEOUT" &
    else
        afplay "$SOUND_DONE" &
    fi
}

# Manual stop
if [ -f "$PID_FILE" ]; then
    kill $(cat "$PID_FILE") 2>/dev/null
    stop_and_transcribe "false"
    exit 0
fi

# Start sound
afplay "$SOUND_START" &

# Record until 7 seconds of silence OR 30 second max
sox -d "$AUDIO" silence 1 0.1 1% 1 7.0 1% trim 0 "$MAX_DURATION" &
echo $! > "$PID_FILE"

# Wait for recording to finish
wait $(cat "$PID_FILE") 2>/dev/null

# If PID file still exists, recording ended on its own (silence or timeout)
if [ -f "$PID_FILE" ]; then
    DURATION=$(sox "$AUDIO" -n stat 2>&1 | grep "Length" | awk '{print $3}' | cut -d. -f1)
    if [ "$DURATION" -ge "$MAX_DURATION" ] 2>/dev/null; then
        stop_and_transcribe "true"
    else
        stop_and_transcribe "false"
    fi
fi
