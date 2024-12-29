#!/bin/bash

trap "echo 'Service stopping...'; kill 0; exit" SIGTERM

# define vars
TIMEOUT=30 # 
SCREEN_OFF_CMD="setterm --blank force --term linux < /dev/tty1"
SCREEN_ON_CMD="setterm --blank poke --term linux < /dev/tty1"
DPMS_PATH="/sys/class/drm/card0-LVDS-1/dpms"

screen_status() {
    if [[ $(cat $DPMS_PATH) == "Off" ]]; then
        echo 0 # off 
    else
        echo 1 # on
    fi
}
# monitor 
monitor_keyboard() {
    while read -r event; do
        current_time=$(date +%s)
        
        # if lcd is OFF ,then ON
        if [[ $screen_status -eq 0 ]]; then
            logger "Screen is off -> on"
            last_activity=$current_time
            eval "$SCREEN_ON_CMD"
        fi
    done < <(stdbuf -oL evtest /dev/input/event0 2>/dev/null | grep --line-buffered "value 1")
}

# main check
check_timeout() {
    while true; do
        sleep 1
        current_time=$(date +%s)
        elapsed=$((current_time - last_activity))
        #logger "screen Checking timeout: $elapsed seconds elapsed."

        # if no key & lcd is ON, then OFF
        if [[ $elapsed -ge $TIMEOUT && $(screen_status) -eq 1 ]]; then
            logger "Screen is on -> off"
            last_activity=$(date +%s)
            eval "$SCREEN_OFF_CMD"
        fi
    done
}

# start task
monitor_keyboard &
check_timeout &
wait 

