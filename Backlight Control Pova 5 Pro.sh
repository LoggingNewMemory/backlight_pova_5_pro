#!/bin/bash
#
# ===     POVA 5 Pro    ===
# === Backlight Control ===
#
# Version: Command-line Argument Mod
#

# Enable LED function (set max current)
enable_led() {
    su -c 'echo 1 > /sys/class/leds/aw22xxx_led/hwen'
    su -c 'echo c > /sys/class/leds/aw22xxx_led/imax'
    su -c 'echo 255 > /sys/class/leds/aw22xxx_led/brightness' 
}

# Read the first argument passed to the script
choice="$1"

case $choice in
    1)
        # Flow
        enable_led
        su -c 'echo 7 > /sys/class/leds/aw22xxx_led/effect'
        su -c 'echo 13 > /sys/class/leds/aw22xxx_led/cfg'
        echo "Flow activated"
        ;;
    2)
        # Breathing
        enable_led
        su -c 'echo 4 > /sys/class/leds/aw22xxx_led/effect'
        su -c 'echo 4 > /sys/class/leds/aw22xxx_led/cfg'
        echo "Breathing activated"
        ;;
    3)
        # Turn Off LEDs
        su -c 'echo 9 > /sys/class/leds/aw22xxx_led/cfg'
        su -c 'echo 0 > /sys/class/leds/aw22xxx_led/hwen'
        echo "LEDs turned off"
        ;;
    *)
        # Show usage if no argument or an invalid one is given
        echo "Usage: $0 [1|2|3]"
        echo "  1: Activate Flow"
        echo "  2: Activate Breathing"
        echo "  3: Turn Off LEDs"
        exit 1
        ;;
esac

exit 0