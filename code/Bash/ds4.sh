#!/bin/bash

#############################################################################################################################################################################
#███████ ██    ██ ███    ██  ██████ ████████ ██  ██████  ███    ██ ███████
#██      ██    ██ ████   ██ ██         ██    ██ ██    ██ ████   ██ ██
#█████   ██    ██ ██ ██  ██ ██         ██    ██ ██    ██ ██ ██  ██ ███████
#██      ██    ██ ██  ██ ██ ██         ██    ██ ██    ██ ██  ██ ██      ██
#██       ██████  ██   ████  ██████    ██    ██  ██████  ██   ████ ███████
#############################################################################################################################################################################
HELP() # SHOW HELP MESSAGE
{
    echo "This is a script to change the color of the LED of the DualShock 4"
    echo
    echo "Options:"
    echo "-h --help            Show this help message"
    echo ""
    echo "-rgb                 Change the led color with the input RGB color"
    echo ""
    echo "-html                Change the led color with the input HTML color"
    echo ""
    echo "-d --default         Set the default color of the LED"
    echo ""
    echo "-b --battery         Start the loop that changes the color of the LED based on the battery level"
    echo ""
    echo "-l --onlaunch        Start the loop that wait for programs to start to change the color of the LED"
    echo ""
    echo "-g --gui             Launch the graphical interface"
    echo ""
}

RGB()
{
    DEVICES=$(udevadm info -a -p $(udevadm info -q path -n /dev/input/js0))
    DEVICES_CONTROLLER="$(echo "$DEVICES" | grep -B 20 -A 20 'ATTRS{name}=="Wireless Controller"')"
    DEVICES_CONTROLLER_ADDRESS="$(echo "$DEVICES_CONTROLLER" | grep -oP '(?<=/).*?(?=input)' | sed 's/.$//' | sed 's@.*/@@')"

    RED="$(echo "$1" | sed 's/,/\n/g' | sed -n '1 p')"
    GREEN="$(echo "$1" | sed 's/,/\n/g' | sed -n '2 p')"
    BLUE="$(echo "$1" | sed 's/,/\n/g' | sed -n '3 p')"

    echo 0 > /sys/class/leds/$DEVICES_CONTROLLER_ADDRESS:red/brightness
    echo 0 > /sys/class/leds/$DEVICES_CONTROLLER_ADDRESS:green/brightness
    echo 0 > /sys/class/leds/$DEVICES_CONTROLLER_ADDRESS:blue/brightness

    sleep 0.5

    echo $RED > /sys/class/leds/$DEVICES_CONTROLLER_ADDRESS:red/brightness
    echo $GREEN > /sys/class/leds/$DEVICES_CONTROLLER_ADDRESS:green/brightness
    echo $BLUE > /sys/class/leds/$DEVICES_CONTROLLER_ADDRESS:blue/brightness
}

HTML()
{
    DEVICES=$(udevadm info -a -p $(udevadm info -q path -n /dev/input/js0))
    DEVICES_CONTROLLER="$(echo "$DEVICES" | grep -B 20 -A 20 'ATTRS{name}=="Wireless Controller"')"
    DEVICES_CONTROLLER_ADDRESS="$(echo "$DEVICES_CONTROLLER" | grep -oP '(?<=/).*?(?=input)' | sed 's/.$//' | sed 's@.*/@@')"

    RED=$((16"#"${1:0:2}))
    GREEN=$((16"#"${1:2:2}))
    BLUE=$((16"#"${1:4:2}))

    echo 0 > /sys/class/leds/$DEVICES_CONTROLLER_ADDRESS:red/brightness
    echo 0 > /sys/class/leds/$DEVICES_CONTROLLER_ADDRESS:green/brightness
    echo 0 > /sys/class/leds/$DEVICES_CONTROLLER_ADDRESS:blue/brightness

    sleep 0.5

    echo $RED > /sys/class/leds/$DEVICES_CONTROLLER_ADDRESS:red/brightness
    echo $GREEN > /sys/class/leds/$DEVICES_CONTROLLER_ADDRESS:green/brightness
    echo $BLUE > /sys/class/leds/$DEVICES_CONTROLLER_ADDRESS:blue/brightness
}

DEFAULT()
{
    while true
    do
        DEFAULT_COLOR="$(cat "/home/YOURUSERNAME/code_data/Bash/ds4_default.txt")"

        if [ -e "/dev/input/js0" ];
        then
            if [ "$(cat "/home/YOURUSERNAME/code_data/Bash/ds4_battery.txt")" = "0" ] && [ "$(cat "/home/YOURUSERNAME/code_data/Bash/ds4_onlaunch.txt")" = "0" ];
            then
                RED_NOW=/sys/class/leds/$DEVICES_CONTROLLER_ADDRESS:red/brightness
                GREEN_NOW=/sys/class/leds/$DEVICES_CONTROLLER_ADDRESS:green/brightness
                BLUE_NOW=/sys/class/leds/$DEVICES_CONTROLLER_ADDRESS:blue/brightness
                COLOR_NOW=$(echo $(cat "$RED_NOW"),$(cat "$GREEN_NOW"),$(cat "$BLUE_NOW"))

                if [ "$COLOR_NOW" != "$DEFAULT_COLOR" ];
                then
                    RGB "$DEFAULT_COLOR"
                fi

            elif [ "$(cat "/home/YOURUSERNAME/code_data/Bash/ds4_battery.txt")" = "1" ] && [ "$(cat "/home/YOURUSERNAME/code_data/Bash/ds4_onlaunch.txt")" = "1" ]:
            then
                echo 0 > "/home/YOURUSERNAME/code_data/Bash/ds4_onlaunch.txt"
                echo 0 > "/home/YOURUSERNAME/code_data/Bash/ds4_battery.txt"

            fi

        fi

        sleep 3
    done
}

BATTERY()
{
    while true
    do
        if [ -e "/dev/input/js0" ];
        then
            DEVICES=$(udevadm info -a -p $(udevadm info -q path -n /dev/input/js0))
            DEVICES_CONTROLLER="$(echo "$DEVICES" | grep -B 20 -A 20 'ATTRS{name}=="Wireless Controller"')"
            DEVICES_CONTROLLER_ADDRESS="$(echo "$DEVICES_CONTROLLER" | grep -oP '(?<=/).*?(?=input)' | sed 's/.$//' | sed 's@.*/@@')"

            DEVICES_CONTROLLER_ID="$(echo "$DEVICES_CONTROLLER" | grep -oP '(?<=ATTRS{uniq}==").*?(?=")')"
            DEVICES_CONTROLLER_ID_BATTERY="/sys/class/power_supply/sony_controller_battery_$DEVICES_CONTROLLER_ID/capacity"

            if [ "$(cat "/home/YOURUSERNAME/code_data/Bash/ds4_battery.txt")" = "1" ] && [ "$(cat "/home/YOURUSERNAME/code_data/Bash/ds4_onlaunch.txt")" = "0" ];
            then
                BATTERY_NOW="$(cat "$DEVICES_CONTROLLER_ID_BATTERY")"

                RED_NOW=/sys/class/leds/$DEVICES_CONTROLLER_ADDRESS:red/brightness
                GREEN_NOW=/sys/class/leds/$DEVICES_CONTROLLER_ADDRESS:green/brightness
                BLUE_NOW=/sys/class/leds/$DEVICES_CONTROLLER_ADDRESS:blue/brightness
                COLOR_NOW=$(echo $(cat "$RED_NOW"),$(cat "$GREEN_NOW"),$(cat "$BLUE_NOW"))

                if [ "$BATTERY_NOW" -gt "75" ];
                then
                    if [ "$COLOR_NOW" != "0,255,0" ];
                    then
                        RGB "0,255,0"
                    fi

                elif [ "$BATTERY_NOW" -gt "50" ] && [ "$BATTERY_NOW" -le "75" ]
                then
                    if [ "$COLOR_NOW" != "0,0,255" ];
                    then
                        RGB "0,0,255"
                    fi

                elif [ "$BATTERY_NOW" -gt "25" ] && [ "$BATTERY_NOW" -le "50" ]
                then
                    if [ "$COLOR_NOW" != "255,255,0" ];
                    then
                        RGB "255,255,0"
                    fi

                elif [ "$BATTERY_NOW" -le "25" ]
                then
                    if [ "$COLOR_NOW" != "255,0,0" ];
                    then
                        RGB "255,0,0"
                    fi
                fi
            fi
        fi
        sleep 3
    done
}

ON_LAUNCH()
{
    SWITCHED=0

    while true
    do
        if [ -e "/dev/input/js0" ];
        then
            if [ "$(cat "/home/YOURUSERNAME/code_data/Bash/ds4_battery.txt")" = "0" ] && [ "$(cat "/home/YOURUSERNAME/code_data/Bash/ds4_onlaunch.txt")" = "1" ];
            then
                if [ "$SWITCHED" = "0" ];
                then
                    while IFS=',' read -ra row;
                    do
                        if [ ! -z "$(pgrep "${row[0]}")" ];
                        then
                            RGB "${row[1]},${row[2]},${row[3]}"
                            SWITCHED=1

                        else
                            :

                        fi
                    done < "/home/YOURUSERNAME/code_data/Bash/ds4_applications.csv"

                elif [ "$SWITCHED" = "1" ]
                then
                    COUNTER=0

                    while IFS=',' read -ra row;
                    do
                        if [ ! -z "$(pgrep "${row[0]}")" ];
                        then
                            COUNTER=$((COUNTER + 1))

                        else
                            :

                        fi

                    done < "/home/YOURUSERNAME/code_data/Bash/ds4_applications.csv"

                    if [ "$COUNTER" = 0 ];
                    then
                        SWITCHED=0
                        DEFAULT_COLOR="$(cat "/home/YOURUSERNAME/code_data/Bash/ds4_default.txt")"
                        RGB "$DEFAULT_COLOR"

                    fi

                fi
            fi
        fi

        sleep 3
    done
}

GUI()
{
    DEVICES=$(udevadm info -a -p $(udevadm info -q path -n /dev/input/js0))
    DEVICES_CONTROLLER="$(echo "$DEVICES" | grep -B 20 -A 20 'ATTRS{name}=="Wireless Controller"')"
    DEVICES_CONTROLLER_ADDRESS="$(echo "$DEVICES_CONTROLLER" | grep -oP '(?<=/).*?(?=input)' | sed 's/.$//' | sed 's@.*/@@')"
    DEVICES_CONTROLLER_ID="$(echo "$DEVICES_CONTROLLER" | grep -oP '(?<=ATTRS{uniq}==").*?(?=")')"

    BATTERY=$(cat "/sys/class/power_supply/sony_controller_battery_$DEVICES_CONTROLLER_ID/capacity")

    COLOR=""
    if [ "$(cat "/home/YOURUSERNAME/code_data/Bash/ds4_default.txt")" =  "0,0,0" ];
    then
        COLOR="OFF"
    else
        COLOR="ON"
    fi

    BAT_TXT=""
    if [ "$(cat "/home/YOURUSERNAME/code_data/Bash/ds4_battery.txt")" = "0" ];
    then
        BAT_TXT="OFF"
    elif [ "$(cat "/home/YOURUSERNAME/code_data/Bash/ds4_battery.txt")" = "1" ];
    then
        BAT_TXT="ON"
    fi

    ONLAUNCH_TXT=""
    if [ "$(cat "/home/YOURUSERNAME/code_data/Bash/ds4_onlaunch.txt")" = "0" ];
    then
        ONLAUNCH_TXT="OFF"
    elif [ "$(cat "/home/YOURUSERNAME/code_data/Bash/ds4_onlaunch.txt")" = "1" ];
    then
        ONLAUNCH_TXT="ON"
    fi

    OPT="$(zenity --width=400 --height=300 --title="DS4 LED CONTROL" --text="<big><b>Battery level: $BATTERY</b></big>" --list --column "Actions" --column "State" "Turn LED on/off" "$COLOR" "Change default LED color" "" "Enable/disable automatic battery LED" "$BAT_TXT" "Enable/disable automatic application LED" "$ONLAUNCH_TXT" "Manage automatic application LED settings" "")"
    if [ "$OPT" = "Turn LED on/off" ];
    then
        if [ "$(cat "/home/YOURUSERNAME/code_data/Bash/ds4_default.txt")" =  "0,0,0" ];
        then
            echo "28,113,216" > "/home/YOURUSERNAME/code_data/Bash/ds4_default.txt"
        else
            echo "0,0,0" > "/home/YOURUSERNAME/code_data/Bash/ds4_default.txt"
            echo 0 > "/home/YOURUSERNAME/code_data/Bash/ds4_onlaunch.txt"
            echo 0 > "/home/YOURUSERNAME/code_data/Bash/ds4_battery.txt"

        fi

    elif [ "$OPT" = "Change default LED color" ]
    then
        COLOR="$(zenity --color-selection --show-palette)"
        RGB="$(echo "$COLOR" | sed -e 's/rgb*(\(.*\))/\1/')"
        echo "$RGB" > "/home/YOURUSERNAME/code_data/Bash/ds4_default.txt"

    elif [ "$OPT" = "Enable/disable automatic battery LED" ]
    then
        if [ "$(cat "/home/YOURUSERNAME/code_data/Bash/ds4_battery.txt")" = "0" ];
        then
            echo "1" > "/home/YOURUSERNAME/code_data/Bash/ds4_battery.txt"

        elif [ "$(cat "/home/YOURUSERNAME/code_data/Bash/ds4_battery.txt")" = "1" ]
        then
            echo "0" > "/home/YOURUSERNAME/code_data/Bash/ds4_battery.txt"
        fi

    elif [ "$OPT" = "Enable/disable automatic application LED" ]
    then
        if [ "$(cat "/home/YOURUSERNAME/code_data/Bash/ds4_onlaunch.txt")" = "0" ];
        then
            echo "1" > "/home/YOURUSERNAME/code_data/Bash/ds4_onlaunch.txt"

        elif [ "$(cat "/home/YOURUSERNAME/code_data/Bash/ds4_onlaunch.txt")" = "1" ]
        then
            echo "0" > "/home/YOURUSERNAME/code_data/Bash/ds4_onlaunch.txt"
        fi

    elif [ "$OPT" = "Manage automatic application LED settings" ]
    then
        LIST=$(while IFS=',' read -r field1 field2; do echo "$field1"; echo "$field2"; done < "/home/YOURUSERNAME/code_data/Bash/ds4_applications.csv")
        LIST_OPT=$(while IFS=',' read -r field1 field2; do echo "FALSE"; echo "$field1"; echo "$field2"; done < "/home/YOURUSERNAME/code_data/Bash/ds4_applications.csv")
        OPT="$(zenity --title="LED APPLICATION MANAGER" --width=800 --height=300 --text="Applications list:" --list --column "Application name" --column "Color" $LIST Add " " Edit " " Remove)"

        if [ "$OPT" == "Add" ]
        then
            ADD_APPLICATION="$(zenity --entry --text="Choose the name of an application to add: \n(Must be the exact name of the process or must be contained in the process name)")"
            zenity --info --text="Choose color for the application:"
            COLOR="$(zenity --color-selection --show-palette)"
            ADD_COLOR="$(echo "$COLOR" | sed -e 's/rgb*(\(.*\))/\1/')"
            if [ ! -z "$ADD_APPLICATION" ] && [ ! -z "$ADD_COLOR" ];
            then
              echo "$ADD_APPLICATION", "$ADD_COLOR" >> "/home/YOURUSERNAME/code_data/Bash/ds4_applications.csv"
            fi
            GUI

        elif [ "$OPT" == "Edit" ]
        then
            EDIT_APPLICATION="$(zenity --title="LED APPLICATION MANAGER" --width=800 --height=300 --text="<big><b>Choose LED application to edit:</b></big>" --list --column " " --column "Application name" --column "Color" $LIST_OPT --radiolist 2>/dev/null)"
            if [ ! -z "$EDIT_APPLICATION" ];
            then
              grep -v "^$EDIT_APPLICATION" "/home/YOURUSERNAME/code_data/Bash/ds4_applications.csv" > "/home/YOURUSERNAME/code_data/Bash/tmp.csv"
              zenity --info --text="Choose new color for the application:"
              COLOR="$(zenity --color-selection --show-palette)"
              EDIT_COLOR="$(echo "$COLOR" | sed -e 's/rgb*(\(.*\))/\1/')"
              mv "/home/YOURUSERNAME/code_data/Bash/tmp.csv" "/home/YOURUSERNAME/code_data/Bash/ds4_applications.csv"
              echo "$EDIT_APPLICATION", "$EDIT_COLOR" >> "/home/YOURUSERNAME/code_data/Bash/ds4_applications.csv"
            fi
            GUI

        elif [ "$OPT" == "Remove" ]
        then
            REMOVE="$(zenity --title="LED APPLICATION MANAGER" --width=800 --height=300 --text="<big><b>Choose LED application to remove:</b></big>" --list --column " " --column "Application name" --column "Color" $LIST_OPT --radiolist 2>/dev/null)"
            if [ ! -z "$REMOVE" ];
            then
              grep -v "^$REMOVE" "/home/YOURUSERNAME/code_data/Bash/ds4_applications.csv" > "/home/YOURUSERNAME/code_data/Bash/tmp.csv"
              mv "/home/YOURUSERNAME/code_data/Bash/tmp.csv" "/home/YOURUSERNAME/code_data/Bash/ds4_applications.csv"
            fi
            GUI

        fi
    fi
}
#############################################################################################################################################################################
#███    ███  █████  ██ ███    ██
#████  ████ ██   ██ ██ ████   ██
#██ ████ ██ ███████ ██ ██ ██  ██
#██  ██  ██ ██   ██ ██ ██  ██ ██
#██      ██ ██   ██ ██ ██   ████
#############################################################################################################################################################################
if [ ! -z "$1" ] && [ ! -z "$2" ] && [ -z "$3" ];
then
    case $1 in

    -html)
        HTML $2
        ;;

    -rgb)
        RGB $2
        ;;

    esac

elif [ ! -z "$1" ] && [ -z "$2" ]
then
    case $1 in

    -h|--help)
        HELP
        ;;

    -d|--default)
        DEFAULT
        ;;

    -b|--battery)
        BATTERY
        ;;

    -l|--onlaunch)
        ON_LAUNCH
        ;;

    -g|--gui)
        GUI
        ;;

    *)
        echo "Use -h or --help to get the list of valid options and know what the program does"
        ;;
    esac

elif [ -z "$1" ]
then
    echo "Use -h or --help to get the list of valid options and know what the program does"
fi
#############################################################################################################################################################################
