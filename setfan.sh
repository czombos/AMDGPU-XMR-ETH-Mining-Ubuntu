#!/bin/bash
  
cards=$(find /sys/class/drm -regextype posix-awk -regex ".*/card[0-9]{1,2}")

for i in $cards
do
  managefilepath="$i/device/power_dpm_force_performance_level"
  echo "$managefilepath set manual" 
  sudo /bin/su -c "echo manual > $managefilepath"

  fanfilepath=$(find "$i"/device/hwmon -regextype posix-awk -regex ".*/hwmon[0-9]{1,2}")/pwm1_enable
  catfan=$(cat "$fanfilepath")
  echo "$fanfilepath set $catfan" 
  sudo /bin/su -c "echo 1 > $fanfilepath"
done
