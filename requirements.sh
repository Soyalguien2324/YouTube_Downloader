#!/bin/bash


if [ $(command -v dialog) ]
then
	:
else
	echo "req package not installed, installing."
	echo "++++++++++++++++"
	echo "enter distro"
	echo "1. Arch Based"
	echo "2. Debian Based"
	echo "3. Fedora Based"
	echo "++++++++++++++++"

	read distro

	if [ $distro -eq 1 ]
	then
		sudo pacman -Syu
		sudo pacman -Sy dialog
	elif [ $distro -eq 2 ]
	then
		sudo apt update && sudo apt install dialog
	elif [ $distro -eq 3 ]
	then
		sudo dnf update && sudo dnf install dialog
	fi

	exit
fi


