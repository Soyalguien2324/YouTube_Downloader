#!/bin/bash
#can change this for custom download folder

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
     
    header_message="+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ AVAILABLE VIDEO FORMATS TO DOWNLOAD ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    printf "$header_message \n\n" >> video_quality.txt
    yt-dlp -F $videolink >> video_quality.txt
    tail_message="+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ READ BELOW INFO. ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    printf "\n\n$tail_message\n\n" >> video_quality.txt

    printf "\n[Please remember the video ID of the quality you want to download, (video id is in the leftmost column.)] \n Alse take a close look at ACODEC(Audio Codec) column, some have video only, no audio." >> video_quality.txt

    #display_message "[keep in mind the video code on the left] \n $quality_information" 100 100
    dialog --textbox ./video_quality.txt 100 400
    rm -rf video_quality.txt
    clear
}

# FUNCTION TO DOWNLOAD VIDEO
download_video() {
    video_code=$1
    folder_to_download=$2
    if [[ $# -eq 3 ]]
    then
		custom_folder=$3
	fi
	
	# storing current path.
    current_path=$(pwd)
    
    if [[ $# -eq 3 ]]
    then
		cd ~/Downloads/$folder_to_download/$custom_folder
    else
		cd ~/Downloads/$folder_to_download
	fi
    
    yt-dlp -f $video_code $videolink
	
	echo "press enter to continue"
	read enter_button
    
    if [[ $# -eq 3 ]]
    then
		display_message "Video Downloaded to $folder_to_download/$custom_folder" 20 60
    else
		display_message "Video Downloaded to $folder_to_download" 20 60
	fi
    
    cd $current_path
}

play_video() {
    videopath="~/Downloads/Videos/$1"
    mpv videopath
    clear
}

checkConnectivity() {
    touch internet_connectivity.txt
    curl -Is youtube.com | head -n 1 > internet_connectivity.txt
    if [[ -s ./internet_connectivity.txt ]]
    then
        display_message_with_wait "[connected to the internet.]" 1 5 40
    else
        display_message "[not connected, try again.]" 5 40
        exit
    fi
    rm -rf internet_connectivity.txt
}

displayFile(){
    file=$1
    dimension_x=$2
    dimension_y=$3
    dialog --textbox $file $dimension_x $dimension_y
    clear
}

MAIN() {
	if [[ $# -eq 1 ]]
	then
		custom_folder=$1
		download_folder_new="~/Downloads/$download_folder/$custom_folder"
	else
		download_folder_new="~/Downloads/$download_folder"
	fi
	
    #checking if folder already present.
    if [[ -d "~/Downloads/$download_folder" ]]
    then
        if [[ $# -eq 1 ]]
        then
			if [[ -d "~/Downloads/$download_folder/$custom_folder" ]]
			then
				:
			else
				mkdir ~/Downloads/$download_folder/$custom_folder
			fi
		fi
    else
        mkdir "~/Downloads/$download_folder"
        if [[ $# -eq 1 ]]
        then
			mkdir ~/Downloads/$download_folder/$custom_folder
		fi
    fi

    display_message "Youtube-Video-Downloader {download folder : $download_folder_new}" 20 50
    
    #checking internet connectivity
    display_message_with_wait "(checking for internet connectivity)" 1 5 40
    checkConnectivity

    #taking video link input
    take_string_input
    touch videotitle.txt # extracting video title
    yt-dlp --get-title $videolink > videotitle.txt
    displayFile videotitle.txt 100 100
    rm -rf videotitle.txt

    show_video_quality $videolink

    touch select_video_quality.txt
    echo "press enter to continue" ; read temp
    dialog --inputbox "Enter Video ID : " 10 29 '' 2> select_video_quality.txt
    clear
    video_quality=$(cat select_video_quality.txt)

    # Download Video
    download_video $video_quality $download_folder $custom_folder

    rm -rf select_video_quality.txt

}

SHOW_FILES() {
    customFolderName=$1
    cd ~/Downloads/$download_folder/$customFolderName
    touch files.txt
    dialog --title "$(pwd) [select any file to play]" --fselect . 15 40 2> files.txt
    file_name=$(cat files.txt)
    # rm -rf files.txt
    mpv file_name
    clear
}

# help method.
if [[ $# -eq 1 ]]
then
	if [[ "$1" == "-h" || "$1" == "--help" ]]
	then
		echo "[Help]"
		echo "-------------------------------------"
		echo "Usage : yt-download <argument> : the argument is optional"
		echo
		echo "Default Download folder, ~/Downloads/YT-Downloads will be created."
		echo
		echo "Extra parameter usage (eg) : "
		echo "	yt-download <my_custom_folder_name> : will download the files in a custom folder inside {~/Downloads/YT-Downloads}"
		echo "Thank You."
        exit
    else
		custom_folder=$1
		#echo "custom download folder: $custom_folder"
		#exit
	fi
elif [[ $# -gt 1 ]]
then
	echo "wrong number of argumets, try again."
	exit
fi



########################################################################
# FUNCTION CALLS
MAIN $custom_folder


#extra items
#SHOW_FILES $custom_folder

#clear the screen after.
clear

