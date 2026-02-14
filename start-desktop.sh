#!/bin/bash
set -eux

echo "Установка Plymouth и необходимых пакетов..."
sudo apt update
sudo apt install -y plymouth plymouth-themes fluxbox xfce4-terminal firefox pcmanfm xserver-xorg xinit

echo "Настройка кастомного Boot Screen..."

echo "Настройка Fluxbox..."
mkdir -p ~/.fluxbox
cat > ~/.fluxbox/startup <<'EOF'
#!/bin/sh
xfce4-terminal &
pcmanfm &
firefox &
exec fluxbox
EOF
chmod +x ~/.fluxbox/startup

echo "Создаем меню Power (Shutdown/Restart)..."
cat > ~/.fluxbox/menu <<'EOF'
[begin] (Fluxbox)
    [exec] (Terminal) {xfce4-terminal}
    [exec] (File Manager) {pcmanfm}
    [exec] (Firefox) {firefox}
    [separator]
    [submenu] (Power)
        [exec] (Shutdown) {systemctl poweroff}
        [exec] (Restart) {systemctl reboot}
    [end]
[end]
EOF

sudo apt install -y xvfb
Xvfb :1 -screen 0 1024x768x16 &
export DISPLAY=:1
startfluxbox &
