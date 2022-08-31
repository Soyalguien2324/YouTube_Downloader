#!/bin/bash

link=$1
verbose=$2

touch videotitle.txt # extracting video title
yt-dlp --get-title $link > videotitle.txt

a=$(cat ./videotitle.txt)


#rm -rf ./videotitle.txt


if [ $verbose -eq 1 ]
then
	echo "download starting for : $a"
fi

# generate the folder
if [ -d ~/Downloads/YT-Downloads ]
then
	:
else
	mkdir ~/Downloads/YT-Downloads
fi



current_path=$(pwd)
cd ~/Downloads/YT-Downloads/

if [ $verbose -eq 1 ]
then
	yt-dlp --progress --write-thumbnail -N 10 -f "bv*+ba/b" $link
else
	yt-dlp -q --write-thumbnail -N 10 -f "bv*+ba/b" $link
fi
cd $current_path



exit
