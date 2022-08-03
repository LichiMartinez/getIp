#!/bin/bash

# Author: Lisandro Martinez (aka lichi)

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"


function helpPanel(){
        echo -e "${yellowColour}Usage:${endColour}"
        echo -e "\t${purpleColour}-i ${redColour}interface:${endColour} Returns the interface ip and copies it to the clipboard"
        echo -e "\t${purpleColour}-l:${endColour} Lists all available interfaces"
        echo -e "\t${purpleColour}-a:${endColour} List of all available interfaces with their ip"

}

function getInterfaces(){
        ifconfig| awk '/: / {print $1}'| tr -d : > getIp.tmp
}

# Main Function

getInterfaces
declare -i parameter_counter=0; while getopts "hlai:" arg; do
	case $arg in
		l)
                        while read -r line;
                        do 
                          echo -e "$yellowColour [+]$endColour $line"
                        done < getIp.tmp
                        ;;
		i)
                        i=$OPTARG
                        inter=$(cat getIp.tmp | grep $i)
                        if [ $(echo $?) == 0 ]; then
                                IP=$(ifconfig $i | awk '{if (NR==2) print $2}')
                                echo -e "${yellowColour} [+]${endColour} [IP]: $IP"                        
                                echo "$IP"| tr -d "\n"| xclip -sel clip
                        else 
                                echo "The requested interface could not be found"
                        fi
                        ;;
                a)
                        while read -r line;
                        do
                                echo -e "${yellowColour} [+]${endColour} ${line}@[IP]: $(ifconfig $line |awk '{if (NR==2) print $2}')" 
                        done < getIp.tmp | column -ts@ 
                        ;;
		h)
                        helpPanel
			exit 1
	esac
done
rm getIp.tmp
