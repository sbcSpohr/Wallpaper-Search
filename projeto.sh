#!/bin/bash

API_KEY="ik0YjRs26fMrgaqQM99P6DnlwEQTtUMvZs4vQpkCPSz7nAlhLtR4GrZg"
API_URL="https://api.pexels.com/v1/search"

output_dir="Wallpapers"
mkdir -p "$output_dir"

read -p "Enter the keyword to serach the wallpapers: " keyword
read -p "Enter how many images you would like to download: " num_images

echo "Searching for $keyword walpappers... "

response=$(curl -G "$API_URL" \
	-H "Authorization: $API_KEY" \
	--data-urlencode "query=$keyword" \
	--data-urlencode "per_page=$num_images" )

echo "$response"


