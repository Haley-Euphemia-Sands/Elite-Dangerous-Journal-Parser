#!/bin/bash
cd "/home/haley/Downloads"
cat "$1" | grep MultiSellExplorationData | jq . | grep SystemName | sed -e 's/\"SystemName\"\: //g' > "$2.csv"
