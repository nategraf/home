#!/usr/bin/env zsh
set -e

# Directory where the script is installed
INSTALL_DIR="$HOME/bin"
SCRIPT_NAME="theme-switcher.sh"
SCRIPT_PATH="${0:A}"
SERVICE_NAME="theme-switcher"
PATCH_PATH="$HOME/light_mode.patch"

# Function to apply or reverse patch based on theme
handle_theme_change() {
    current_theme=$(gsettings get org.gnome.desktop.interface color-scheme)
    echo "Theme is now $current_theme"
    
    if [[ $current_theme == "'prefer-light'" ]]; then
        # Switch to light mode
        pushd $HOME
        git apply "$PATCH_PATH" || true
        echo "Switched to light mode at $(date)" >> "$HOME/.theme-switcher.log"
        popd
    else
        # Switch to dark mode
        pushd $HOME
        git apply -R "$PATCH_PATH" || true
        echo "Switched to dark mode at $(date)" >> "$HOME/.theme-switcher.log"
        popd
    fi
}

# Create systemd service file
create_service_file() {
    cat >| "$HOME/.config/systemd/user/$SERVICE_NAME.service" << EOL
[Unit]
Description=Monitor system theme changes and apply patches
PartOf=graphical-session.target

[Service]
ExecStart=$SCRIPT_PATH monitor
Restart=always
Environment=DISPLAY=:0

[Install]
WantedBy=default.target
EOL
}

# Install the monitor script
install_script() {
    mkdir -p "$HOME/.config/systemd/user"
    create_service_file
    
    systemctl --user daemon-reload
    systemctl --user enable "$SERVICE_NAME"
    systemctl --user start "$SERVICE_NAME"
    
    echo "Theme switcher installed and started"
}

# Monitor for theme changes
monitor_theme() {
    handle_theme_change  # Initial run to match current theme
    
    dbus-monitor --session "type='signal',interface='ca.desrt.dconf.Writer'" |
    while read -r line; do
        if echo "$line" | grep -q 'string "desktop/interface/color-scheme"'; then
            echo "Detected a theme change"
            sleep 1  # Small delay to ensure gsettings has updated
            handle_theme_change
        fi
    done
}

# Main script logic
case "${1:-}" in
    "install")
      install_script
        ;;
    "monitor")
        monitor_theme
        ;;
    *)
        echo "Usage: $0 {install|monitor}"
        echo "Run '$0 install' to set up the theme switcher service"
        echo ""
        echo "Check the current status with systemctl"
        echo "systemctl --user status theme-switcher"
        exit 1
        ;;
esac
