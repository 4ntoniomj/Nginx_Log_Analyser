#!/bin/bash
clear

redColour="\e[0;31m"
endColour="\e[0m"

# FILE
if [ -z $1 ]; then
	file=$(find . -type f -name *.log | head -n 1)
else
	file="$1"
fi

if [ ! -f "$file" ]; then
	echo -e "${redColour}[!] File log not found${endColour}"
fi


# ANALYSER
# mostip
cut -d " " -f1 "$file" | sort | uniq -c | sort -rn | head -5 | awk 'BEGIN {print "Top 5 IP addresses with the most requests"};{print $1" - "$2}'
echo
# most request
grep -E '(GET|POST|PUT|DELETE|HEAD) \/' "$file" | awk -F '\"' '{print $2}' | awk '{print $2}' | sort | uniq -c | sort -rn | head -5 | awk 'BEGIN {print "Top 5 most requested paths:"}; {print $2" - "$1}'
echo
# response status
grep -E 'HTTP\/[0-2]\.[0-9]\" [1-5][0-9]{2}' "$file" -o | awk '{print $2}' | sort -n | uniq -c | sort -rn | head -n 5 | awk 'BEGIN {print "Top 5 response status codes:"}; {print $2" - "$1}'
