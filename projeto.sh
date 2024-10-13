#!/bin/bash

API_KEY="ik0YjRs26fMrgaqQM99P6DnlwEQTtUMvZs4vQpkCPSz7nAlhLtR4GrZg"
API_URL="https://api.pexels.com/v1/search"

output_dir="Wallpapers"
mkdir -p "$output_dir"

read -p "Enter the keyword to search the wallpapers: " keyword
read -p "Enter how many images you would like to download: " num_images

echo "Searching for $keyword wallpapers... "

response=$(curl -G "$API_URL" \
	-H "Authorization: $API_KEY" \
	--data-urlencode "query=$keyword" \
	--data-urlencode "per_page=$num_images" )

echo "$response"

if [[ -z "$response" ]]; then
	echo "No response from the API. Exiting."
	exit 1
fi

images_urls=$(jq -r '.photos[].src.original' <<< "$response")

if [[ -z "$images_urls" ]]; then
	echo "No images found for the keyword: '$keyword'. Exiting."
	exit 1
fi

count=1
for url in $images_urls; do
	file_name="$output_dir/${keyword}_${count}.jpg"

	echo "Downloading image $count: $url"

	curl -L "$url" -o "$file_name"

	((count++))
done

echo "Images saved."
