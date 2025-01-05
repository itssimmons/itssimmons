#!/usr/bin/dash

RESPONSE=$(curl -s https://wttr.in?format=3 | sed 's/ //g' | cut -d ":" -f 2)
CELSIUS=$(echo "$RESPONSE" | cut -c 2-)

sed -i "/<!--START_SECTION:weather-->/,/<!--END_SECTION:weather-->/c\
<!--START_SECTION:weather-->\
- 🌤 Working at <b>${CELSIUS}</b>\
<!--END_SECTION:weather-->" README.md
