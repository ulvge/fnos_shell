#!/bin/bash

trap "echo 'Service stopping...'; kill 0; exit" SIGTERM

# define vars
TIMEOUT=60 # 
SCREEN_OFF_CMD="setterm --blank force --term linux < /dev/tty1"
SCREEN_ON_CMD="setterm --blank poke --term linux < /dev/tty1"
DPMS_PATH="/sys/class/drm/card0-LVDS-1/dpms"

last_activity=$(date +%s)
# last_activity
LAST_ACTIVITY_FILE="/tmp/last_activity"


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
        last_act=$(date +%s)
        echo "$last_act" > $LAST_ACTIVITY_FILE
        # logger "monitor last_activity: $last_act"
        # if lcd is OFF ,then ON
        if [[ $screen_status -eq 0 ]]; then
            logger "Screen is off -> on"
            eval "$SCREEN_ON_CMD"
        fi
    done < <(stdbuf -oL evtest /dev/input/event0 2>/dev/null | grep --line-buffered "value 1")
}

# main check
check_timeout() {
    while true; do
        sleep 3
        current_time=$(date +%s)

        # last_activity
        if [[ -f $LAST_ACTIVITY_FILE ]]; then
            last_activity=$(cat $LAST_ACTIVITY_FILE)
        fi

        elapsed=$((current_time - last_activity))
        #logger "screen Checking timeout: $elapsed seconds elapsed."
        #logger "last_activity: $last_activity"

        # if no key & lcd is ON, then OFF
        if [[ $elapsed -ge $TIMEOUT && $(screen_status) -eq 1 ]]; then
            logger "Screen is on -> off"
            eval "$SCREEN_OFF_CMD"
        fi
    done
}

# start task
monitor_keyboard &
check_timeout &
wait 

