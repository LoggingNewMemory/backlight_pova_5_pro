#!/bin/bash
#
# ===     POVA 5 Pro    ===
# === Backlight Control ===
#
# Version: Simplified Mod (Renamed)
#

# Enable LED function (set max current)
enable_led() {
    su -c 'echo 1 > /sys/class/leds/aw22xxx_led/hwen'
    su -c 'echo c > /sys/class/leds/aw22xxx_led/imax'
    su -c 'echo 255 > /sys/class/leds/aw22xxx_led/brightness' 
}

# Main menu
show_menu() {
    clear
    echo "=== POVA 5 Pro (Simplified) ==="
    echo ""
    echo "1. Flow"
    echo "2. Breathing"
    echo "3. Turn Off LEDs"
    echo ""
    echo "Q. Quit"
    echo ""
}

# Main loop
while true; do
    show_menu
    echo -ne "Select option [1-3/Q]: "
    read main_choice
    
    case $main_choice in
        1)
            # Original: Menu 2, Option 2 (Music Party Mode)
            enable_led
            su -c 'echo 7 > /sys/class/leds/aw22xxx_led/effect'
            su -c 'echo 13 > /sys/class/leds/aw22xxx_led/cfg'
            echo "Flow activated"
            sleep 1
            ;;
        2)
            # Original: Menu 4, Option 1 (Skyline Incoming)
            enable_led
            su -c 'echo 4 > /sys/class/leds/aw22xxx_led/effect'
            su -c 'echo 4 > /sys/class/leds/aw22xxx_led/cfg'
            echo "Breathing activated"
            sleep 1
            ;;
        3)
            # Original: Menu 0
            su -c 'echo 9 > /sys/class/leds/aw22xxx_led/cfg'
            su -c 'echo 0 > /sys/class/leds/aw22xxx_led/hwen'
            echo "LEDs turned off"
            sleep 1
            ;;
        q|Q)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid choice!"
            sleep 1
            ;;
    esac
done