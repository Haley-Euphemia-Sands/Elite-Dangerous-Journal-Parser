#!/bin/bash

#-------------------------------------------------------#
#							#
#	argv | 1 = mode, 2 = the change to working dir,	#
#	3 = journal filename, 4 = output filename. 	#
#			5 = Submode			#
#							#
#-------------------------------------------------------#


helpcall() {
	printf "help:\n<script> [mode] <working dir> <input> <output> <submode>\nModes\nuc : Universal Cartographics Mode\nucp : Universal Cartographics Profit Mode\nmsg : Message History Mode\nmuc : Missed Universal Cartographics Mode \n- lists Bodies you have discovered but not mapped that are Terraformable, Water Worlds, Ammonia Worlds, and Earthlike.\n the submode can be a/A w/W e/E t/T for Ammonia, Water, Earth-like, and Terraformable worlds it shouldn't matter what order as long as there are no spaces. \n\n\nC:\\Users\\<User Name>\\Saved Games\\Frontier Developments\\Elite Dangerous\\ is the Usual location to find the Journal\nAlternatively you can use journals downloaded from your own Journal Limpet at https://journal-limpet.com/\n"
}

mode="$1" && pwdir="$2" && journal="$3" && output="$4" && submode=$5;


#	Check if the other arguments are a valid argument.
if  [ "$pwdir" != "" ] && [ "$journal" != "" ] && [ "$output" != "" ]; then
	printf "mode = $mode\nworking dir = $pwdir\njournal = $journal\noutput = $output\n" >&2
	cd "$pwdir"
	case "$mode" in
		#       Universal Cartographics Mode : puts all the listed system names in csv sheet.
		"uc" ) 
			printf "Universal Cartographic Mode\n" >&2
			printf "System Name,\n" > "$output"
			jq '. | select(.event == "MultiSellExplorationData").SystemName' $journal >> "$output";;
		#       Universal Cartographics Profit : puts all the credits per transaction in csv sheet.
		"ucp" )
			printf "Universal Cartographics Profit Mode\n" >&2
			printf "Credit Profits,\n" > "$output"
			jq '. |  select(event == "MultiSellExplorationData").TotalEarnings ' $journal >> "$output";;
		"msg" )
			printf "Message Mode\n" >&2
			printf "Message History,\n" > "$output"
			if [ "$(printf "$submode" | grep n)" != ""] || [ "$(printf "$submode" | grep N)" != "" ]; then 
				inclnpc=1
			fi
			if [ "$(printf "$submode" | grep s)" != "" ] || [ "$(printf "$submode" | grep S)" != ""]; then
				inclself=1
			fi
			if [ "$(printf "$submode" | grep p)" != ""] || [ "$(printf "$submode" | grep P)" != ""]; then 
				inclplayers=1
			fi
			if [ $inclnpc != 1] && [ $inclself != 1] && [ $inclplayers !=1]; then
				inclnpc=1
				inclself=1
				inclplayers=1
			fi
			if [ $inclnpc == 1 ] && [ $inclself == 1] && [ $inclplayers == 1 ]; then 
				jq '. | select((.event == "ReceiveText") or (.event == "SendText")).Message' $journal >> $output
			elif [ $inclnpc != 1 ] && [ $inclself == 1 ] && [ $inclplayers == 1 ]; then 
				jq '. | select(((.event == "ReceiveText") and (.Channel != "npc")) or (.event == "SendText")).Message' $journal >> $output
			elif [ $inclnpc == 1 ] && [ $inclself !=1 ] && [ $inclplayers == 1 ]; then
				jq '. | select(.event == "ReceiveText").Message' $journal >> $output
			elif [ $inclnpc == 1 ] && [ $inclself == 1 ] && [ $inclplayers != 1 ]; then 
				jq '. | select(((.event == ReceiveText") and (.Channel == "npc")) or (.event == "SendText")).Message' $journal >> $output
			elif [ $inclnpc != 1 ] && [ $inclself != 1 ] && [ $inclplayers == 1 ]; then
				jq '. | select((.event == "ReceiveText") and (.Channel != "npc")).Message' $journal >> $output
			elif [ $inclnpc == 1 ] && [ $inclself != 1 ] && [ $inclplayers != 1 ]; then
				jq '. | select((.event == "ReceiveText") and (.Channel == "npc")).Message' $journal >> $output
			else
				jq '. | select(.event == "SendText").Message' $journal >> $output
			fi;;
		"muc" )
			printf "Missed Universal Cartographics Mode\n" >&2
			if [ "$submode" == "" ]; then 
				submode="aetw"
			fi
			if [ "$(printf "$submode" | grep t)" != "" ] || [ "$(printf "$submode" | grep T)" != "" ]; then 
				jq '. | select(.TerraformState == "Terraformable").BodyName' $journal >> working.tmp; 
			fi
			if [ "$(printf "$submode" | grep e)" != "" ] || [ "$(printf "$submode" | grep E)" != "" ]; then 
				jq '. | select(.PlanetClass == "Earthlike body").BodyName' $journal >> working.tmp; 
			fi
			if [ "$(printf "$submode" | grep w)" != "" ] || [ "$(printf "$submode" | grep W)" != "" ]; then 
				jq '. | select(.PlanetClass == "Water world").BodyName' $journal >> working.tmp; 
			fi
			if [ "$(printf "$submode" | grep a)" != "" ] || [ "$(printf "$submode" | grep A)" != "" ]; then 
				jq '. | select(.PlanetClass == "Ammonia world").BodyName' $journal >> working.tmp; 
			fi
			comm -13 <(jq  '. | select(.event == "SAAScanComplete").BodyName' $journal | sort -u) <(sort -u < working.tmp) >> "$output"
			rm working.tmp;;
	esac
# 	Help mode.
elif [ "$mode" == "help" ]; then 
	printf "Help mode Called!\n" >&2
	helpcall
#	Displays help in the case that one or more arguments are invalid.
else 
	printf "Invalid Argument!\n" >&2
	helpcall;
fi
