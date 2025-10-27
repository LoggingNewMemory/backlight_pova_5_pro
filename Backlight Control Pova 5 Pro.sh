#!/bin/bash
#
# ===     POVA 5 Pro    ===
# === Backlight Control ===
#
# Version 3: Removed System Info
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
    echo "===     POVA 5 Pro    ==="
    echo "=== Backlight Control ==="
    echo ""
    echo "1. Dynamic Effects"
    echo "2. Music Effects"
    echo "3. Game Effects"
    echo "4. Status Effects (Charging/Incoming)"
    echo "5. Other & Test Effects"
    echo "6. Custom Settings"
    echo "0. Turn Off LEDs"
    echo ""
    echo "Q. Quit"
    echo ""
}

# 1. Dynamic effects menu
dynamic_effects_menu() {
    clear
    echo "=== Dynamic Effects ==="
    echo ""
    echo "1. Breathing (Pure Mode)      [cfg: 1c]"
    echo "2. Breathing (Party Mode)     [cfg: 1d]"
    echo "3. Collision (Double Flash 1) [cfg: 3]"
    echo "4. Collision (Double Flash 2) [cfg: 17]"
    echo "5. Collision (Double Flash 3) [cfg: 18]"
    echo "6. Collision (Double Flash 4) [cfg: 19]"
    echo "7. Collision (Double Flash 5) [cfg: 1a]"
    echo "8. Flash                      [cfg: 2]"
    echo "9. Back"
    echo ""
    echo -ne "Select option [1-9]: "
}

# 2. Audio effects menu
music_effects_menu() {
    clear
    echo "=== Music Effects ==="
    echo ""
    echo "1. Music (Pure Mode)      [cfg: 12]"
    echo "2. Music (Party Mode)     [cfg: 13]"
    echo "3. Back"
    echo ""
    echo -ne "Select option [1-3]: "
}

# 3. Game effects menu
game_effects_menu() {
    clear
    echo "=== Game Effects ==="
    echo " (Note: Assumes 'effect 8' for all game modes)"
    echo ""
    echo "--- Static ---"
    echo "1. Static Game 1            [cfg: 5]"
    echo "2. Static Game 2            [cfg: 1b]"
    echo "--- PUBG ---"
    echo "3. PUBG: Shoot              [cfg: 14]"
    echo "4. PUBG: Sight              [cfg: 15]"
    echo "5. PUBG: Drive              [cfg: 16]"
    echo "--- MLBB ---"
    echo "6. MLBB: First Blood        [cfg: 1e]"
    echo "7. MLBB: One Kill           [cfg: 1f]"
    echo "8. MLBB: Double Kill        [cfg: 20]"
    echo "9. MLBB: Triple Kill        [cfg: 21]"
    echo "10. MLBB: Quadra Kill       [cfg: 22]"
    echo "11. MLBB: Penta Kill        [cfg: 23]"
    echo "12. MLBB: Killing Spree     [cfg: 24]"
    echo "13. Back"
    echo ""
    echo -ne "Select option [1-13]: "
}

# 4. Status effects menu
status_effects_menu() {
    clear
    echo "=== Status Effects ==="
    echo " (Note: Assumes 'effect 4' for all status modes)"
    echo ""
    echo "1. Skyline (Incoming)       [cfg: 4]"
    echo "2. Charging                 [cfg: 1]"
    echo "3. Charging (Alt)           [cfg: 11]"
    echo "4. Fully Charged            [cfg: 10]"
    echo "5. Back"
    echo ""
    echo -ne "Select option [1-5]: "
}

# 5. Other & Test effects menu
other_effects_menu() {
    clear
    echo "=== Other & Test Effects ==="
    echo ""
    echo "--- Static / Test ---"
    echo "1. All On                   [cfg: 0]"
    echo "2. Test Mode                [cfg: f]"
    echo "--- Power On ---"
    echo "3. Power On (Stage 1)       [cfg: 6]"
    echo "4. Power On (Stage 2)       [cfg: 7]"
    echo "--- Raw Audio (Dev) ---"
    echo "5. Audio (CTOS)             [cfg: b]"
    echo "6. Audio (PWM)              [cfg: c]"
    echo "7. Audio (Single Dir)       [cfg: d]"
    echo "8. Audio (STOC)             [cfg: e]"
    echo "9. Back"
    echo ""
    echo -ne "Select option [1-9]: "
}


# 6. Custom settings menu
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

# Main loop
while true; do
    show_menu
    echo -ne "Select option [0-6/Q]: "
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
                        echo "Collision (Flash 1) activated"
                        sleep 1
                        ;;
                    4)
                        enable_led
                        su -c 'echo 3 > /sys/class/leds/aw22xxx_led/effect'
                        su -c 'echo 17 > /sys/class/leds/aw22xxx_led/cfg'
                        echo "Collision (Flash 2) activated"
                        sleep 1
                        ;;
                    5)
                        enable_led
                        su -c 'echo 3 > /sys/class/leds/aw22xxx_led/effect'
                        su -c 'echo 18 > /sys/class/leds/aw22xxx_led/cfg'
                        echo "Collision (Flash 3) activated"
                        sleep 1
                        ;;
                    6)
                        enable_led
                        su -c 'echo 3 > /sys/class/leds/aw22xxx_led/effect'
                        su -c 'echo 19 > /sys/class/leds/aw22xxx_led/cfg'
                        echo "Collision (Flash 4) activated"
                        sleep 1
                        ;;
                    7)
                        enable_led
                        su -c 'echo 3 > /sys/class/leds/aw22xxx_led/effect'
                        su -c 'echo 1a > /sys/class/leds/aw22xxx_led/cfg'
                        echo "Collision (Flash 5) activated"
                        sleep 1
                        ;;
                    8)
                        enable_led
                        su -c 'echo 5 > /sys/class/leds/aw22xxx_led/effect'
                        su -c 'echo 2 > /sys/class/leds/aw22xxx_led/cfg'
                        echo "Flash activated"
                        sleep 1
                        ;;
                    9)
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
                game_effects_menu
                read game_choice
                
                # We assume 'effect 8' for all game modes. This may need testing.
                GAME_EFFECT=8
                
                case $game_choice in
                    1)
                        enable_led
                        su -c "echo $GAME_EFFECT > /sys/class/leds/aw22xxx_led/effect"
                        su -c "echo 5 > /sys/class/leds/aw22xxx_led/cfg"
                        echo "Static Game 1 activated"
                        sleep 1
                        ;;
                    2)
                        enable_led
                        su -c "echo $GAME_EFFECT > /sys/class/leds/aw22xxx_led/effect"
                        su -c "echo 1b > /sys/class/leds/aw22xxx_led/cfg"
                        echo "Static Game 2 activated"
                        sleep 1
                        ;;
                    3)
                        enable_led
                        su -c "echo $GAME_EFFECT > /sys/class/leds/aw22xxx_led/effect"
                        su -c "echo 14 > /sys/class/leds/aw22xxx_led/cfg"
                        echo "PUBG: Shoot activated"
                        sleep 1
                        ;;
                    4)
                        enable_led
                        su -c "echo $GAME_EFFECT > /sys/class/leds/aw22xxx_led/effect"
                        su -c "echo 15 > /sys/class/leds/aw22xxx_led/cfg"
                        echo "PUBG: Sight activated"
                        sleep 1
                        ;;
                    5)
                        enable_led
                        su -c "echo $GAME_EFFECT > /sys/class/leds/aw22xxx_led/effect"
                        su -c "echo 16 > /sys/class/leds/aw22xxx_led/cfg"
                        echo "PUBG: Drive activated"
                        sleep 1
                        ;;
                    6)
                        enable_led
                        su -c "echo $GAME_EFFECT > /sys/class/leds/aw22xxx_led/effect"
                        su -c "echo 1e > /sys/class/leds/aw22xxx_led/cfg"
                        echo "MLBB: First Blood activated"
                        sleep 1
                        ;;
                    7)
                        enable_led
                        su -c "echo $GAME_EFFECT > /sys/class/leds/aw22xxx_led/effect"
                        su -c "echo 1f > /sys/class/leds/aw22xxx_led/cfg"
                        echo "MLBB: One Kill activated"
                        sleep 1
                        ;;
                    8)
                        enable_led
                        su -c "echo $GAME_EFFECT > /sys/class/leds/aw22xxx_led/effect"
                        su -c "echo 20 > /sys/class/leds/aw22xxx_led/cfg"
                        echo "MLBB: Double Kill activated"
                        sleep 1
                        ;;
                    9)
                        enable_led
                        su -c "echo $GAME_EFFECT > /sys/class/leds/aw22xxx_led/effect"
                        su -c "echo 21 > /sys/class/leds/aw22xxx_led/cfg"
                        echo "MLBB: Triple Kill activated"
                        sleep 1
                        ;;
                    10)
                        enable_led
                        su -c "echo $GAME_EFFECT > /sys/class/leds/aw22xxx_led/effect"
                        su -c "echo 22 > /sys/class/leds/aw22xxx_led/cfg"
                        echo "MLBB: Quadra Kill activated"
                        sleep 1
                        ;;
                    11)
                        enable_led
                        su -c "echo $GAME_EFFECT > /sys/class/leds/aw22xxx_led/effect"
                        su -c "echo 23 > /sys/class/leds/aw22xxx_led/cfg"
                        echo "MLBB: Penta Kill activated"
                        sleep 1
                        ;;
                    12)
                        enable_led
                        su -c "echo $GAME_EFFECT > /sys/class/leds/aw22xxx_led/effect"
                        su -c "echo 24 > /sys/class/leds/aw22xxx_led/cfg"
                        echo "MLBB: Killing Spree activated"
                        sleep 1
                        ;;
                    13)
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
                status_effects_menu
                read status_choice
                
                # We assume 'effect 4' (like Skyline/Incoming) for all status modes.
                STATUS_EFFECT=4

                case $status_choice in
                    1)
                        enable_led
                        su -c "echo $STATUS_EFFECT > /sys/class/leds/aw22xxx_led/effect"
                        su -c 'echo 4 > /sys/class/leds/aw22xxx_led/cfg'
                        echo "Skyline (Incoming) activated"
                        sleep 1
                        ;;
                    2)
                        enable_led
                        su -c "echo $STATUS_EFFECT > /sys/class/leds/aw22xxx_led/effect"
                        su -c 'echo 1 > /sys/class/leds/aw22xxx_led/cfg'
                        echo "Charging activated"
                        sleep 1
                        ;;
                    3)
                        enable_led
                        su -c "echo $STATUS_EFFECT > /sys/class/leds/aw22xxx_led/effect"
                        su -c 'echo 11 > /sys/class/leds/aw22xxx_led/cfg'
                        echo "Charging (Alt) activated"
                        sleep 1
                        ;;
                    4)
                        enable_led
                        su -c "echo $STATUS_EFFECT > /sys/class/leds/aw22xxx_led/effect"
                        su -c 'echo 10 > /sys/class/leds/aw22xxx_led/cfg'
                        echo "Fully Charged activated"
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
        5)
            while true; do
                other_effects_menu
                read other_choice
                
                case $other_choice in
                    1)
                        enable_led
                        # Assumes 'effect 5' (like Flash)
                        su -c 'echo 5 > /sys/class/leds/aw22xxx_led/effect'
                        su -c 'echo 0 > /sys/class/leds/aw22xxx_led/cfg'
                        echo "All On activated"
                        sleep 1
                        ;;
                    2)
                        enable_led
                        # Assumes 'effect 5' (like Flash)
                        su -c 'echo 5 > /sys/class/leds/aw22xxx_led/effect'
                        su -c 'echo f > /sys/class/leds/aw22xxx_led/cfg'
                        echo "Test Mode activated"
                        sleep 1
                        ;;
                    3)
                        enable_led
                        # Assumes 'effect 1' (unused in original script)
                        su -c 'echo 1 > /sys/class/leds/aw22xxx_led/effect'
                        su -c 'echo 6 > /sys/class/leds/aw22xxx_led/cfg'
                        echo "Power On (Stage 1) activated"
                        sleep 1
                        ;;
                    4)
                        enable_led
                        # Assumes 'effect 1' (unused in original script)
                        su -c 'echo 1 > /sys/class/leds/aw22xxx_led/effect'
                        su -c 'echo 7 > /sys/class/leds/aw22xxx_led/cfg'
                        echo "Power On (Stage 2) activated"
                        sleep 1
                        ;;
                    5)
                        enable_led
                        # Assumes 'effect 7' (like Music)
                        su -c 'echo 7 > /sys/class/leds/aw22xxx_led/effect'
                        su -c 'echo b > /sys/class/leds/aw22xxx_led/cfg'
                        echo "Audio (CTOS) activated"
                        sleep 1
                        ;;
                    6)
                        enable_led
                        # Assumes 'effect 7' (like Music)
                        su -c 'echo 7 > /sys/class/leds/aw22xxx_led/effect'
                        su -c 'echo c > /sys/class/leds/aw22xxx_led/cfg'
                        echo "Audio (PWM) activated"
                        sleep 1
                        ;;
                    7)
                        enable_led
                        # Assumes 'effect 7' (like Music)
                        su -c 'echo 7 > /sys/class/leds/aw22xxx_led/effect'
                        su -c 'echo d > /sys/class/leds/aw22xxx_led/cfg'
                        echo "Audio (Single Dir) activated"
                        sleep 1
                        ;;
                    8)
                        enable_led
                        # Assumes 'effect 7' (like Music)
                        su -c 'echo 7 > /sys/class/leds/aw22xxx_led/effect'
                        su -c 'echo e > /sys/class/leds/aw22xxx_led/cfg'
                        echo "Audio (STOC) activated"
                        sleep 1
                        ;;
                    9)
                        break
                        ;;
                    *)
                        echo "Invalid choice!"
                        sleep 1
                        ;;
                esac
            done
            ;;
        6)
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