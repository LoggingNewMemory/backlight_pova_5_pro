#!/bin/bash

enable_led() {
    echo 1 > /sys/class/leds/aw22xxx_led/hwen
    echo c > /sys/class/leds/aw22xxx_led/imax
    echo 255 > /sys/class/leds/aw22xxx_led/brightness 
}

choice="$1"

case $choice in
    1)
        enable_led
        echo 7 > /sys/class/leds/aw22xxx_led/effect
        echo 13 > /sys/class/leds/aw22xxx_led/cfg
        echo "Flow activated"
        ;;
    2)
        enable_led
        echo 4 > /sys/class/leds/aw22xxx_led/effect
        echo 4 > /sys/class/leds/aw22xxx_led/cfg
        echo "Breathing activated"
        ;;
    3)
        echo 9 > /sys/class/leds/aw22xxx_led/cfg
        echo 0 > /sys/class/leds/aw22xxx_led/hwen
        echo "LEDs turned off"
        ;;
    *)
        echo "Usage: $0 [1|2|3]"
        echo "  1: Activate Flow"
        echo "  2: Activate Breathing"
        echo "  3: Turn Off LEDs"
        exit 1
        ;;
esac

exit 0