#!/bin/bash

# Script to kill the chrome/msedge tab process that eat most memory
# Run every 60 Sec
# useful on low performace laptop, when you open many tabs.

while true; do
  overloaded=$(free -m | awk 'NR==2{if ($3*100/$2 > 85) printf "1"; else printf "0";}')
  used_mem=$(free -m | awk 'NR==2{printf "%.2f%%\n", $3*100/$2 }')
  now=$(date)
  if (( ${overloaded} )); then
    echo "${now}: Overloaded memory detected: ${used_mem}, trying to kill fatest Chrome/Edge tab..."
  
    # Find chrome/msedge tab process that eat most memory
    pid=$(ps -C chrome,msedge  -o pid,user,%mem,cmd --sort=%mem --no-header | grep 'renderer' | grep -v extension | tail -n 1 | awk '{print $1}')
  
    # Kill that process process
    if [ ! -z "$pid" ]; then
      echo "Killing Chrome/Edge tab process with PID $pid"
      kill "$pid"
    else
      echo "No Chrome/Edge tab processes found"
    fi

  else
    echo "${now}: Mem usage: ${used_mem}"
  fi
  sleep 60
done
