#!/usr/bin/dash

CELSIUS=$(curl -s https://es.wttr.in/Buenos%20Aires?format=1)

sed -i "/<!--START_SECTION:weather-->/,/<!--END_SECTION:weather-->/c\\
<!--START_SECTION:weather-->\\
Working at <b>${CELSIUS}</b>\\
<!--END_SECTION:weather-->\\
" README.md
