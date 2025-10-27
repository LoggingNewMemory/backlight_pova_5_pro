#!/system/bin/sh

# System constants
MAX_BRIGHTNESS=255
DEFAULT_RGB="0000000000000000"

# Enable LED function
enable_led() {
    su -c "echo c > /sys/class/leds/aw22xxx_led/imax"
}

# Main menu
show_menu() {
    clear
    echo "===     POVA 5 Pro    ==="
    echo "=== Backlight Control ==="
    echo ""
    echo "1. Dynamic Effects"
    echo "2. Music Effects"
    echo "3. Custom Settings"
    echo "0. Turn Off LEDs"
    echo ""
    echo "S. System Info"
    echo "Q. Quit"
    echo ""
}

# Dynamic effects menu
dynamic_effects_menu() {
    clear
    echo "=== Dynamic Effects ==="
    echo ""
    echo "1. Breathing (Pure Mode)"
    echo "2. Breathing (Party Mode)"
    echo "3. Collision (Double Flash)"
    echo "4. Skyline (Incoming)"
    echo "5. Flash"
    echo "6. Back"
    echo ""
    echo -ne "Select option [1-6]: "
}

# Audio effects menu
music_effects_menu() {
    clear
    echo "=== Music Effects ==="
    echo ""
    echo "1. Music (Pure Mode)"
    echo "2. Music (Party Mode)"
    echo "3. Back"
    echo ""
    echo -ne "Select option [1-3]: "
}

# Custom settings menu
custom_settings_menu() {
    clear
    echo "=== Custom Settings ==="
    echo ""
    echo "1. Set RGB (16-digit HEX)"
    echo "2. Set Current (IMAX)"
    echo "3. Back"
    echo ""
    echo -ne "Select option [1-3]: "
}

# System information
system_info() {
    clear
    echo "=== System Information ==="
    echo ""
    echo -n "Current effect: "; su -c 'cat /sys/class/leds/aw22xxx_led/effect'
    echo -n "Current config: "; su -c 'cat /sys/class/leds/aw22xxx_led/cfg | grep "current cfg"'
    echo -n "Brightness: "; su -c 'cat /sys/class/leds/aw22xxx_led/brightness'
    echo -n "Current IMAX: "; su -c 'cat /sys/class/leds/aw22xxx_led/imax | grep "current id"'
    echo -n "RGB values: "; su -c 'cat /sys/class/leds/aw22xxx_led/rgb'
    echo ""
    echo "Press Enter to continue..."
    read
}

# Main loop
while true; do
    show_menu
    echo -ne "Select option [0-3/S/Q]: "
    read main_choice
    
    case $main_choice in
        0)
            su -c 'echo 9 > /sys/class/leds/aw22xxx_led/cfg'
            su -c 'echo 0 > /sys/class/leds/aw22xxx_led/hwen'
            echo "LEDs turned off"
            sleep 1
            ;;
        1)
            while true; do
                dynamic_effects_menu
                read effect_choice
                
                case $effect_choice in
                    1)
                        enable_led
                        su -c 'echo 2 > /sys/class/leds/aw22xxx_led/effect'
                        su -c 'echo 1c > /sys/class/leds/aw22xxx_led/cfg'
                        echo "Breathing (Pure) activated"
                        sleep 1
                        ;;
                    2)
                        enable_led
                        su -c 'echo 2 > /sys/class/leds/aw22xxx_led/effect'
                        su -c 'echo 1d > /sys/class/leds/aw22xxx_led/cfg'
                        echo "Breathing (Party) activated"
                        sleep 1
                        ;;
                    3)
                        enable_led
                        su -c 'echo 3 > /sys/class/leds/aw22xxx_led/effect'
                        su -c 'echo 3 > /sys/class/leds/aw22xxx_led/cfg'
                        echo "Collision (Double Flash) activated"
                        sleep 1
                        ;;
                    4)
                        enable_led
                        su -c 'echo 4 > /sys/class/leds/aw22xxx_led/effect'
                        su -c 'echo 4 > /sys/class/leds/aw22xxx_led/cfg'
                        echo "Skyline (Incoming) activated"
                        sleep 1
                        ;;
                    5)
                        enable_led
                        su -c 'echo 5 > /sys/class/leds/aw22xxx_led/effect'
                        su -c 'echo 2 > /sys/class/leds/aw22xxx_led/cfg'
                        echo "Flash activated"
                        sleep 1
                        ;;
                    6)
                        break
                        ;;
                    *)
                        echo "Invalid choice!"
                        sleep 1
                        ;;
                esac
            done
            ;;
        2)
            while true; do
                music_effects_menu
                read audio_choice
                
                case $audio_choice in
                    1)
                        enable_led
                        su -c 'echo 6 > /sys/class/leds/aw22xxx_led/effect'
                        su -c 'echo 12 > /sys/class/leds/aw22xxx_led/cfg'
                        echo "Music (Pure Mode) activated"
                        sleep 1
                        ;;
                    2)
                        enable_led
                        su -c 'echo 7 > /sys/class/leds/aw22xxx_led/effect'
                        su -c 'echo 13 > /sys/class/leds/aw22xxx_led/cfg'
                        echo "Music (Party Mode) activated"
                        sleep 1
                        ;;
                    3)
                        break
                        ;;
                    *)
                        echo "Invalid choice!"
                        sleep 1
                        ;;
                esac
            done
            ;;
        3)
            while true; do
                custom_settings_menu
                read custom_choice
                
                case $custom_choice in
                    1)
                        echo -ne "Enter 16-digit HEX RGB value: "
                        read rgb
                        su -c "echo $rgb > /sys/class/leds/aw22xxx_led/rgb"
                        echo "RGB values updated"
                        sleep 1
                        ;;
                    2)
                        echo "Available current levels:"
                        su -c 'cat /sys/class/leds/aw22xxx_led/imax | grep AW22XXX_IMAX'
                        echo -ne "Enter level number (0-b): "
                        read imax
                        su -c "echo $imax > /sys/class/leds/aw22xxx_led/imax"
                        echo "Current level set"
                        sleep 1
                        ;;
                    3)
                        break
                        ;;
                    *)
                        echo "Invalid choice!"
                        sleep 1
                        ;;
                esac
            done
            ;;
        s|S)
            system_info
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