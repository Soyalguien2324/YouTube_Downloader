#!/bin/bash

download_folder="YT-Downloads"
display_message() {
    message=$1
    dimension_x=$2
    dimension_y=$3
    dialog --msgbox "$message" $dimension_x $dimension_y
    clear
}

display_message_with_wait() {
    message=$1
    time=$2
    dimension_x=$3
    dimension_y=$4
    dialog --infobox "$message" $dimension_x $dimension_y ; sleep $time
    clear
}
videolink=''
take_string_input() {
    touch take_string_input.txt
    dialog --inputbox "Enter YouTube link : " 25 50 '' 2> take_string_input.txt
    videolink=$(cat take_string_input.txt)
    rm -rf take_string_input.txt
    clear
}

show_video_quality() {
    touch video_quality.txt
    
    yt-dlp -F $videolink > video_quality.txt
    
    printf "\n[Please remember the video ID of the quality you want to download, (video id is in the leftmost column.)]" >> video_quality.txt

    #display_message "[keep in mind the video code on the left] \n $quality_information" 100 100
    dialog --textbox ./video_quality.txt 100 400
    rm -rf video_quality.txt
    clear
}

download_video() {
    video_code=$1
    current_path=$(pwd)
    cd ~/Downloads/$download_folder
    yt-dlp -f $video_code $videolink
    display_message "Video Downloaded to ~/Downloads/$download_folder" 20 60
    cd $current_path
}

play_video() {
    videopath="~/Downloads/Videos/$1"
    mpv videopath
    clear
}



mkdir ~/Downloads/$download_folder

display_message YouTube-Video-Downloader 5 30
display_message_with_wait "(checking for internet connectivity)" 1 5 40

touch internet_connectivity.txt
curl -Is google.in | head -n 1 > internet_connectivity.txt
if [[ -s ./internet_connectivity.txt ]]
then
    display_message_with_wait "[connected to net.]" 1 5 40
else
    display_message "[not connected, try again.]" 5 30
    exit
fi
rm -rf internet_connectivity.txt


# download file
#take inp
take_string_input
touch videotitle.txt
yt-dlp --get-title $videolink > videotitle.txt
videotitle=$(cat videotitle.txt)
display_message "$videotitle" 30 100
rm -rf videotitle.txt

#show video quality
show_video_quality $videolink

touch select_video_quality.txt
echo "press enter"
read temp
#dialog --inputbox "Enter the quality code of the video:[video code is in the left]" 4 10 '' 2> select_video_quality.txt

dialog --inputbox "Enter video code : " 10 25 '' 2> select_video_quality.txt

clear
video_quality=$(cat select_video_quality.txt)
download_video $video_quality
rm -rf select_video_quality.txt



