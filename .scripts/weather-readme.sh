#!/usr/bin/bash

CELSIUS=$(curl -s "https://es.wttr.in/Buenos%20Aires?format=1&m")

if [[ "$CELSIUS" == *"Unknown location"* ]]; then
  CELSIUS="N/A"
fi

sed -i "/<!--START_SECTION:weather-->/,/<!--END_SECTION:weather-->/c\\
\t\t<!--START_SECTION:weather-->\\
\t\tWorking at <b>${CELSIUS}</b>\\
\t\t<!--END_SECTION:weather-->\
" README.md
