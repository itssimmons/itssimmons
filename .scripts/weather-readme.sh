#!/usr/bin/dash

CELSIUS=$(curl -s https://es.wttr.in/Buenos+Aires?format=1&m)

sed -i "/<!--START_SECTION:weather-->/,/<!--END_SECTION:weather-->/c\\
<!--START_SECTION:weather-->\\
Working at <b>${CELSIUS}</b>\\
<!--END_SECTION:weather-->\\
" README.md
