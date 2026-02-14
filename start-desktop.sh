#!/bin/bash
set -eux

echo "Установка Fluxbox и необходимых пакетов..."
sudo apt update
sudo apt install -y fluxbox xfce4-terminal pcmanfm firefox x11-xserver-utils xvfb

echo "Настройка Fluxbox..."
mkdir -p ~/.fluxbox

# startup
cat > ~/.fluxbox/startup <<'EOF'
#!/bin/sh
xfce4-terminal &
pcmanfm &
firefox &
exec fluxbox
EOF
chmod +x ~/.fluxbox/startup

# меню Fluxbox
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

# fluxbox.cat
cat > ~/.fluxbox/fluxbox.cat <<'EOF'
Fluxbox.Title: BoyJack OS v1.0
Menu.Terminal: Терминал
Menu.FileManager: Файловый менеджер
Menu.Firefox: Firefox
Menu.Power: Питание
Menu.Shutdown: Выключение
Menu.Restart: Перезагрузка
Tip.CloseWindow: Закрыть окно
Tip.MinimizeWindow: Свернуть окно
Tip.MaximizeWindow: Развернуть окно
Tip.RestoreWindow: Восстановить окно
Tip.MenuRoot: Главное меню
Tip.MenuWindow: Меню окна
Tip.MenuWorkspace: Рабочее пространство
EOF

# --- Запуск Xvfb и Fluxbox ---
if [ -z "${DISPLAY:-}" ] || ! pgrep Xorg >/dev/null 2>&1; then
    echo "Запуск виртуального Xvfb..."
    Xvfb :1 -screen 0 1024x768x16 &
    export DISPLAY=:1
fi

echo "Запуск Fluxbox..."
startfluxbox &
