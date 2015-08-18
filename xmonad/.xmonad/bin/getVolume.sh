#!/bin/bash
#Get volume from alsa
mixer=$(amixer get Master | awk -F'[\[\]]' '{if ($4 =="off") {print "[off] "; } else { print $2; }}' | tail -n 1 | head -c -2)
echo $mixer
