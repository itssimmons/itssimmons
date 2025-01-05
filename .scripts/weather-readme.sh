#!/usr/bin/bash

RESPONSE=$(curl -s https://wttr.in?format=3 | sed 's/ //g' | cut -d ":" -f 2)
CELSIUS=${RESPONSE:1}

sed -i "/<!--START_SECTION:weather-->/,/<!--END_SECTION:weather-->/c\
<!--START_SECTION:weather-->\
- 🌤 Working at <b>${CELSIUS}</b>\
<!--END_SECTION:weather-->" README.md
