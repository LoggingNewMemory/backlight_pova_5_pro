#!/system/bin/sh

# System constants
DEFAULT_RGB="0000000000000000"
MAX_BRIGHTNESS=255

# Enable LED function
enable_led() {
    su -c 'echo 1 > /sys/class/leds/aw22xxx_led/hwen'
    su -c "echo $DEFAULT_RGB > /sys/class/leds/aw22xxx_led/rgb"
    su -c 'echo c > /sys/class/leds/aw22xxx_led/hwen'
}

# Main menu
show_menu() {
    clear
    echo "=== TECNO POVA 5 PRO ==="
    echo "===  BACKLIGHT CTRL  ==="
    echo ""
    echo "1. Basic Effects"
    echo "2. Static Colors"
    echo "3. Audio Effects"
    echo "4. Game Modes"
    echo "5. Custom Settings"
    echo "0. Turn Off LEDs"
    echo ""
    echo "S. System Info"
    echo "Q. Quit"
    echo ""
}

# Basic effects menu
basic_effects_menu() {
    clear
    echo "=== Basic Effects ==="
    echo ""
    echo "1. Breathing"
    echo "2. Collision"
    echo "3. Skyline"
    echo "4. Flower"
    echo "5. Back"
    echo ""
    echo -n "Select option [1-5]: "
}

# Static colors menu
static_colors_menu() {
    clear
    echo "=== Static Colors ==="
    echo ""
    echo "1. Red"
    echo "2. Green"
    echo "3. Blue"
    echo "4. Yellow"
    echo "5. Custom RGB"
    echo "6. Back"
    echo ""
    echo -n "Select option [1-6]: "
}

# Audio effects menu
audio_effects_menu() {
    clear
    echo "=== Audio Effects ==="
    echo ""
    echo "1. Audio Skyline"
    echo "2. Audio Flower"
    echo "3. Back"
    echo ""
    echo -n "Select option [1-3]: "
}

# Game modes menu
game_modes_menu() {
    clear
    echo "=== Game Modes ==="
    echo ""
    echo "1. Game Mode"
    echo "2. Back"
    echo ""
    echo -n "Select option [1-2]: "
}

# Custom settings menu
custom_settings_menu() {
    clear
    echo "=== Custom Settings ==="
    echo ""
    echo "1. Set Brightness"
    echo "2. Set RGB"
    echo "3. Set Current (IMAX)"
    echo "4. Back"
    echo ""
    echo -n "Select option [1-4]: "
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
    echo -n "Select option [0-5/S/Q]: "
    read main_choice
    
    case $main_choice in
        0)
            su -c 'echo 0 > /sys/class/leds/aw22xxx_led/hwen'
            echo "LEDs turned off"
            sleep 1
            ;;
        1)
            while true; do
                basic_effects_menu
                read effect_choice
                
                case $effect_choice in
                    1)
                        enable_led
                        su -c 'echo 2 > /sys/class/leds/aw22xxx_led/effect'
                        su -c 'echo 1 > /sys/class/leds/aw22xxx_led/cfg'
                        echo "Breathing effect activated"
                        sleep 1
                        ;;
                    2)
                        enable_led
                        su -c 'echo 3 > /sys/class/leds/aw22xxx_led/effect'
                        su -c 'echo 1 > /sys/class/leds/aw22xxx_led/cfg'
                        echo "Collision effect activated"
                        sleep 1
                        ;;
                    3)
                        enable_led
                        su -c 'echo 4 > /sys/class/leds/aw22xxx_led/effect'
                        su -c 'echo 1 > /sys/class/leds/aw22xxx_led/cfg'
                        echo "Skyline effect activated"
                        sleep 1
                        ;;
                    4)
                        enable_led
                        su -c 'echo 5 > /sys/class/leds/aw22xxx_led/effect'
                        su -c 'echo 1 > /sys/class/leds/aw22xxx_led/cfg'
                        echo "Flower effect activated"
                        sleep 1
                        ;;
                    5)
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
                static_colors_menu
                read color_choice
                
                case $color_choice in
                    1)
                        enable_led
                        su -c 'echo 8 > /sys/class/leds/aw22xxx_led/effect'
                        su -c 'echo 1 > /sys/class/leds/aw22xxx_led/cfg'
                        echo "Red color activated"
                        sleep 1
                        ;;
                    2)
                        enable_led
                        su -c 'echo 9 > /sys/class/leds/aw22xxx_led/effect'
                        su -c 'echo 1 > /sys/class/leds/aw22xxx_led/cfg'
                        echo "Green color activated"
                        sleep 1
                        ;;
                    3)
                        enable_led
                        su -c 'echo 10 > /sys/class/leds/aw22xxx_led/effect'
                        su -c 'echo 1 > /sys/class/leds/aw22xxx_led/cfg'
                        echo "Blue color activated"
                        sleep 1
                        ;;
                    4)
                        enable_led
                        # Fixed yellow color - using RGB combination instead of effect 11
                        su -c 'echo "255 255 0" > /sys/class/leds/aw22xxx_led/task0'
                        echo "Yellow color activated"
                        sleep 1
                        ;;
                    5)
                        echo -n "Enter RGB values (R G B, 0-255): "
                        read r g b
                        enable_led
                        su -c "echo \"$r $g $b\" > /sys/class/leds/aw22xxx_led/task0"
                        echo "Custom RGB color set"
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
        3)
            while true; do
                audio_effects_menu
                read audio_choice
                
                case $audio_choice in
                    1)
                        enable_led
                        su -c 'echo 6 > /sys/class/leds/aw22xxx_led/effect'
                        su -c 'echo 1 > /sys/class/leds/aw22xxx_led/cfg'
                        echo "Audio skyline activated"
                        sleep 1
                        ;;
                    2)
                        enable_led
                        su -c 'echo 7 > /sys/class/leds/aw22xxx_led/effect'
                        su -c 'echo 1 > /sys/class/leds/aw22xxx_led/cfg'
                        echo "Audio flower activated"
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
        4)
            while true; do
                game_modes_menu
                read game_choice
                
                case $game_choice in
                    1)
                        enable_led
                        su -c 'echo 12 > /sys/class/leds/aw22xxx_led/effect'
                        su -c 'echo 1 > /sys/class/leds/aw22xxx_led/cfg'
                        echo "Game mode activated"
                        sleep 1
                        ;;
                    2)
                        break
                        ;;
                    *)
                        echo "Invalid choice!"
                        sleep 1
                        ;;
                esac
            done
            ;;
        5)
            while true; do
                custom_settings_menu
                read custom_choice
                
                case $custom_choice in
                    1)
                        echo -n "Enter brightness (0-$MAX_BRIGHTNESS): "
                        read brightness
                        su -c "echo $brightness > /sys/class/leds/aw22xxx_led/brightness"
                        echo "Brightness set to $brightness"
                        sleep 1
                        ;;
                    2)
                        echo -n "Enter 16-digit HEX RGB value: "
                        read rgb
                        su -c "echo $rgb > /sys/class/leds/aw22xxx_led/rgb"
                        echo "RGB values updated"
                        sleep 1
                        ;;
                    3)
                        echo "Available current levels:"
                        su -c 'cat /sys/class/leds/aw22xxx_led/imax | grep AW22XXX_IMAX'
                        echo -n "Enter level number (0-b): "
                        read imax
                        su -c "echo $imax > /sys/class/leds/aw22xxx_led/imax"
                        echo "Current level set"
                        sleep 1
                        ;;
                    4)
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