#!/bin/bash

#-------------------------------------------------------#
#							#
#	argv | 1 = mode, 2 = the change to working dir,	#
#	3 = journal filename, 4 = output filename.	#
#							#
#-------------------------------------------------------#

helpinfo="help:\n<script> [mode] <input> <output>\nModes\nuc : Universal Cartographics Mode\nucp : Universal Cartographics Profit Mode\n";

mode="$1" && pwdir="$2" && journal="$3" && output="$4";

#	Check if the other arguments are a valid argument.
if  [ "$pwdir" != "" ] && [ "$journal" != "" ] && [ "$output" != "" ]; then
	printf "mode = $mode\nworking dir = $pwdir\njournal = $journal\noutput = $output.csv\n" >&2
	cd "$pwdir"
	case "$mode" in
		#       Universal Cartographics Mode : puts all the listed system names in csv sheet.
		"uc" ) 
			cat "$journal" | grep MultiSellExplorationData | jq . | grep SystemName | sed -e 's/\"SystemName\"\: //g' > "$output.csv";;
		#       Universal Cartographics Profit : puts all the credits per transaction in csv sheet.
		"ucp" )
			cat "$journal" | grep MultiSellExplorationData | jq . | grep TotalEarnings | sed -e 's/\"TotalEarnings\":\ //g' > "$output.csv";;
		#	Help
	esac
# 	Help mode.
elif [ "$mode" == "help" ]; then 
	printf "Help mode Called!\n" >&2
	printf "$helpinfo";
#	Displays help in the case that one or more arguments are invalid.
else 
	printf "Invalid Argument!\n" >&2
	printf "$helpinfo";
fi
