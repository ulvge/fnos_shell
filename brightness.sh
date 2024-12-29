
#!/bin/bash

# if there is para 
if [ -z "$1" ]; then
    echo "default max = 7, now max"
    brightness=7
fi

brightness=$1

# set brightness
echo "$brightness" > /sys/class/backlight/acpi_video0/brightness



