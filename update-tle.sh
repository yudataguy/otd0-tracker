#!/bin/sh
# Refresh the SD-1 SAT orbital elements embedded in index.html.
# Run this (with internet) before a demo; the page then works offline.
set -e
cd "$(dirname "$0")"
TLE=$(curl -fsS https://hyvrid.yonsei.ac.kr/tle/nuri5 | grep -A2 '^SD-1')
L1=$(printf '%s\n' "$TLE" | sed -n 2p | tr -d '\r')
L2=$(printf '%s\n' "$TLE" | sed -n 3p | tr -d '\r')
case "$L1" in "1 "*) ;; *) echo "Could not find SD-1 TLE"; exit 1;; esac
sed -i.bak -e "s|^  l1:'.*',\$|  l1:'$L1',|" -e "s|^  l2:'.*',\$|  l2:'$L2',|" index.html && rm index.html.bak
# bump the offline cache so installed home-screen copies pick up the new file
sed -i.bak "s/sd1-tracker-v[0-9]*/sd1-tracker-v$(date +%s)/" sw.js && rm sw.js.bak
echo "Updated SD-1 TLE:"; printf '%s\n%s\n' "$L1" "$L2"
