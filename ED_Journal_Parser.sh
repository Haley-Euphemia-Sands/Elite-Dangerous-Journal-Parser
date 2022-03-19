#!/bin/bash

#-------------------------------------------------------#
#							#
#	argv | 1 = mode, 2 = the change to working dir,	#
#	3 = journal filename, 4 = output filename.	#
#							#
#-------------------------------------------------------#

helpinfo="help:\n<script> [mode] <working dir> <input> <output>\nModes\nuc : Universal Cartographics Mode\nucp : Universal Cartographics Profit Mode\nmsg : Message History Mode\nmuc : Missed Universal Cartographics Mode \n- lists Bodies you have discovered but not mapped that are Terraformable, Water Worlds, Ammonia Worlds, and Earthlike.\ntmuc emuc amuc wmuc : same as muc just terraformable only, eartlikes only, ammonia worlds only, and water worlds only respectivily \n\n\nC:\Users\<User Name>\Saved Games\Frontier Developments\Elite Dangerous\ is the Usual location to find the Journal\nAlternatively you can use journals downloaded from your own Journal Limpet at https://journal-limpet.com/\n";
mucm="Missed Universal Cartographics"

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
			jq '. | select(.event == "MultiSellExplorationData").SystemName' $journal >> "$output.csv";;
		#       Universal Cartographics Profit : puts all the credits per transaction in csv sheet.
		"ucp" )
			printf "Universal Cartographics Profit Mode\n" >&2
			printf "Credit Profits,\n" > "$output.csv"
			jq '. |  select(event == "MultiSellExplorationData).TotalEarnings ' $journal >> "$output.csv";;
		"msg" )
			printf "Message Mode\n" >&2
			printf "Message History,\n" > "$output.csv"
			jq '. | select((.event == "ReceiveText") or (.event == "SendText")).Message' $journal >> "$output.csv";;
		"muc" )
			printf "$mucm Mode\n" >&2
			comm -13 <(jq  '. | select(.event == "SAAScanComplete").BodyName' $journal | sort -u) <(jq '. | select((.TerraformState == "Terraformable") or (.PlanetClass == "Earthlike body") or (.PlanetClass == "Ammonia world") or (.PlanetClass == "Water world")).BodyName' $journal | sort -u) >> "$output";;
		"tmuc" )
			printf "$mucm - Terraformable Mode\n" >&2
			comm -13 <(jq '. | select(.event == "SAAScanComplete").BodyName' $journal | sort -u) <(jq '. | select(.TerraformState == "Terraformable").BodyName' $journal | sort -u >> "$output";;
		"emuc" )
			printf "$mucm - Earth-like Mode\n" >&2
			comm -13 <(jq '. | select(.event == "SAAScanComplete").BodyName' $journal | sort -u) <(jq '. | select(.PlanetClass == "Earthlike body").BodyName' $journal | sort -u >> "$output";;
		"amuc" )
			printf "$mucm - Ammonia World Mode\n" >&2
			comm -13 <(jq '. | select(.event == "SAAScanComplete").BodyName' $journal | sort -u) <(jq '. | select(.PlanetClass == "Ammonia world").BodyName' $journal | sort -u >> "$output";;
		"wmuc" ) 
			printf "$mucm - Water World Mode\n" >&2
			comm -13 <(jq '. | select(.event == "SAAScanComplete").BodyName' $journal | sort -u) <(jq '. | select(.PlanetClass == "Water world").BodyName' $journal | sort -u >> "$output";;
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
