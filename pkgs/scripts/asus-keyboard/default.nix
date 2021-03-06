{ pkgs, ... }:

pkgs.writeScript "asus-keybaord" ''
  #!/usr/bin/env bash

  # Shell script to modify the ASUS Keyboard LED backlight Brightness
  # Must be run as root

  # This script is licensed CC0 by Andrew Harvey <andrew.harvey4@gmail.com>
  #
  # To the extent possible under law, the person who associated CC0
  # with this work has waived all copyright and related or neighboring
  # rights to this work.
  # http://creativecommons.org/publicdomain/zero/1.0/

  if [ "$1" == "" ] ; then
      echo "Usage: $0 (up|down|min|max|off|on|0..n)"
      exit
  fi

  function kb_backlight {
      echo $1 > /sys/devices/platform/asus-nb-wmi/leds/asus\:\:kbd_backlight/brightness
  }

  kb=`cat /sys/devices/platform/asus-nb-wmi/leds/asus\:\:kbd_backlight/brightness`
  max_kb=`cat /sys/devices/platform/asus-nb-wmi/leds/asus\:\:kbd_backlight/max_brightness`

  if [ "$1" == "up" ] ; then
      if [ $kb -lt $max_kb ] ; then
          kb_backlight $(($kb + 1))
      fi
  elif [ "$1" == "down" ] ; then
      if [ $kb -gt 0 ] ; then
          kb_backlight $(($kb - 1))
      fi
  elif [ "$1" == "min" ] ; then
      kb_backlight 0
  elif [ "$1" == "off" ] ; then
      kb_backlight 0
  elif [ "$1" == "max" ] ; then
      kb_backlight $max_kb
  elif [ "$1" == "on" ] ; then
      kb_backlight $max_kb
  elif [[ ( "$1" -ge 0 ) && ( "$1" -le $max_kb ) ]] ; then
      kb_backlight $1
  fi
''
