#!/bin/bash

echo
echo     " -----------------------------------------------------"
echo    "|                                                     |"
echo    "|                  Wallpaper-Searcher                 |"
echo    "|                                                     |"
echo     " -----------------------------------------------------"

source ./config/config.sh

b() {
	echo "$1" | sed 's/Mb/M/g'
}

A=$(b "$a")
API_URL="https://api.pexels.com/v1/search"

script_dir=$(dirname "$(realpath "$0")")
output_dir="$script_dir/Wallpapers"

rm -rf "$output_dir"
mkdir -p "$output_dir"

echo
read -p "-- Enter the keyword to search the wallpapers: " keyword
echo
read -p "-- Enter how many images you would like to download: " num_images
echo
echo "-- Searching for $keyword wallpapers... "
echo

response=$(curl -G "$API_URL" \
    -H "Authorization: $A" \
    --data-urlencode "query=$keyword" \
    --data-urlencode "per_page=$num_images")

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

	if (( count > num_images )); then
		break
	fi

	file_name="$output_dir/${keyword}_${count}.jpg"

	echo "Downloading image $count: $url"

	curl -L -s "$url" -o "$file_name"

	((count++))
done

echo "Images saved."
