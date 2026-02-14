#!/bin/bash
set -eu

cleanup() {
    echo "Cleaning up..."
    kill $(jobs -p) 2>/dev/null || true
    rm -f /tmp/.X1-lock /tmp/.X11-unix/X1 2>/dev/null || true
}
trap cleanup EXIT

rm -f /tmp/.X1-lock /tmp/.X11-unix/X1 2>/dev/null || true

export HOME=/home/runner/workspace

mkdir -p "$HOME/.fluxbox"

sudo apt install -y xkb-data

# используем дисплей 99
export DISPLAY=:99

# старт Xvfb
Xvfb $DISPLAY -screen 0 1024x768x24 -nolisten tcp &
XVFB_PID=$!
sleep 5  # ждем, пока Xvfb поднимется

# старт fluxbox
fluxbox >/dev/null 2>&1 &
sleep 3

# старт x11vnc
x11vnc -display $DISPLAY -nopw -forever -shared >/dev/null 2>&1 &
VNC_PID=$!

echo "Xvfb PID=$XVFB_PID, x11vnc PID=$VNC_PID"
wait
