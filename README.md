## rtinst

#### 30 Second Guide

Ubuntu and Debian Seedbox Installation

Download and run setup (if logged in directly as root, do not need to use sudo)

	sudo bash -c "$(wget --no-check-certificate -qO - https://raw.githubusercontent.com/mrlongshen/rtinst/master/rtsetup)"

and then to run the main script,

	sudo rtinst

It takes about 10 minutes to run, depending on your server setup. 
After you have run the script and everything is working, I suggest a reboot, the script does not automate this reboot, you need to do it manually using the reboot command.


It has been tested with clean installs of: 

	Ubuntu 16
	Debian 8
	Debian 9

Services that will be installed and configured are

	1. vsftpd port 2018
	2. libtorrent/rtorrent
	3. rutorrent 0.9.6
	4. Nginx (webserver)
	5. autodl-irssi
	6. webmin
	7. ssh port 2017

This is my repo clone from rtinst. This script has been edit for personal use. 
Please dont use it if you not understand.
-------------------------------------------------------------------------
