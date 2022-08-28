#!/bin/bash


# checking for requirements.

distro=$1
verbose_mode=$2

pip_install=0

if [ $(command -v pip) ]
then
	pip_install=1
fi

if [ $verbose_mode -eq 1 ]
then
	echo "checking requirements.."
fi

sleep 0.67

if [[ $(command -v yt-dlp) && $pip_install -eq 1 ]]
then
	if [ $verbose_mode -eq 1 ]
	then
		echo "requirements fullfilled"
	fi
	:
else
	echo "installing required dependencies"

	if [ $distro -eq 1 ]
	then
		# arch
		sudo pacman -S yt-dlp python-pip
		

	elif [ $distro -eq 2 ]
	then
		# debian
		sudo apt install yt-dlp python3-pip
	else
		# fedora
		sudo dnf install yt-dlp python-pip
	fi
fi

if [[ $verbose_mode -eq 1 && $pip_install -eq 1 ]]
then
	echo "installing required python packages"
	pip install numpy rich
fi
exit


