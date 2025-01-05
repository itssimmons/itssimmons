#!/usr/bin/dash

CELSIUS=$(curl -s "https://es.wttr.in/Buenos+Aires?format=1&m")

sed -i "/<!--START_SECTION:weather-->/,/<!--END_SECTION:weather-->/c\\
\t\t<!--START_SECTION:weather-->\\
\t\tWorking at <b>${CELSIUS}</b>\\
\t\t<!--END_SECTION:weather-->\
" README.md
