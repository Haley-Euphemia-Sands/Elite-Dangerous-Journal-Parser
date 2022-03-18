#!/bin/bash

#-------------------------------------------------------#
#							#
#	argv | 1 = mode, 2 = the change to working dir,	#
#	3 = journal filename, 4 = output filename.	#
#							#
#-------------------------------------------------------#

helpinfo="help:\n<script> [mode] <working dir> <input> <output>\nModes\nuc : Universal Cartographics Mode\nucp : Universal Cartographics Profit Mode\nmsg : Message History Mode\n\n\nC:\Users\<User Name>\Saved Games\Frontier Developments\Elite Dangerous\ is the Usual location to find the Journal\nAlternatively you can use journals downloaded from your own Journal Limpet at https://journal-limpet.com/\n";

mode="$1" && pwdir="$2" && journal="$3" && output="$4";

#	Check if the other arguments are a valid argument.
if  [ "$pwdir" != "" ] && [ "$journal" != "" ] && [ "$output" != "" ]; then
	printf "mode = $mode\nworking dir = $pwdir\njournal = $journal\noutput = $output.csv\n" >&2
	cd "$pwdir"
	case "$mode" in
		#       Universal Cartographics Mode : puts all the listed system names in csv sheet.
		"uc" ) 
			printf "Universal Cartographic Mode\n" >&2
			printf "System Name,\n" > "$output.csv"
			cat "$journal" | grep MultiSellExplorationData | jq . | grep SystemName | sed -e 's/\"SystemName\"\: //g' >> "$output.csv";;
		#       Universal Cartographics Profit : puts all the credits per transaction in csv sheet.
		"ucp" )
			printf "Universal Cartographics Profit Mode\n" >&2
			printf "Credit Profits,\n" > "$output.csv"
			cat "$journal" | grep MultiSellExplorationData | jq . | grep TotalEarnings | sed -e 's/\"TotalEarnings\":\ //g' >> "$output.csv";;
		"msg" )
			printf "Message Mode\n" >&2
			printf "Message History,\n" > "$output.csv"
			cat "$journal" | grep Message | jq . | grep Message | sed -e 's/\"Message\"://g' | sed -e 's/\"Message_Localised\"://g' >> "$output.csv";;
		"muc" )
			cat "$journal" | jq '. | select((.TerraformState == "Terraformable") and (.WasMapped == false)).BodyName' >> "$output.json"
			cat "$journal" | jq '. | select((.PlanetClass == "Earthlike body") and (.WasMapped == false)).BodyName' >> "$output.json"
			cat "$journal" | jq '. | select((.PlanetClass == "Ammonia world") and (.WasMapped == false)).BodyName' >> "$output.json"
			cat "$journal" | jq '. | select((.PlanetClass == "Water world") and (.WasMapped == false).)BodyName' >> "$output.json";;
		"tmuc" )
			cat "$journal" | jq '. | select((.TerraformState == "Terraformable") and (.WasMapped == false)).BodyName' >> "$output.json";;
		"emuc" )
			cat "$journal" | jq '. | select((.PlanetClass == "Earthlike body") and (.WasMapped == false)).BodyName' >> "$output.json";;
		"amuc" )
			cat "$journal" | jq '. | select((.PlanetClass == "Ammonia world") and (.WasMapped == false)).BodyName' >> "$output.json";;
		"wmuc" ) 
			cat "$journal" | jq '. | select((.PlanetClass == "Water world") and (.WasMapped == false)).BodyName' >> "$output.json";;
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
