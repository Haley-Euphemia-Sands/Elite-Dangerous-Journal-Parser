#!/bin/bash
lts=$1
au=$(printf "scale=12; $LS*1/499" | bc)
printf "$lts Light Seconds equals $au Astronomical Units\n"
