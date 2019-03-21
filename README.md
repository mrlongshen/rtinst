## INSTALLATION

Ubuntu and Debian Seedbox Installation

Services that will be installed and configured are

	1. vsftpd port 2018
	2. libtorrent/rtorrent
	3. rutorrent 0.9.6
	4. Nginx (webserver)
	5. autodl-irssi
	6. webmin
	7. ssh port 2017

	bash -c "$(wget --no-check-certificate -qO - https://raw.githubusercontent.com/mrlongshen/rtinst/master/rtsetup)"

Run
	rtinst

After you have run the script and everything is working, Please reboot your server.

## LAZY SCRIPT

Download and run setup (if logged in directly as root, do not need to use sudo)

	sudo bash -c "$(wget --no-check-certificate -qO - https://raw.githubusercontent.com/mrlongshen/rtinst/master/lazyscript.sh)"

	chmod +x lazyscript.sh
	
	./lazyscript.sh
	
Services that will be installed and configured are

	1. rutorrent plugins
	2. rutorrent themes
	3. Install quota
	4. Install vnstat
	5.
	6. 
	
subversion: apt-get install subversion

Installation
quotaspace

$ cd /var/www/rutorrent/plugins/plugins
$ svn co https://github.com/mrlongshen/plugins/trunk/quotaspace

This is my repo clone from rtinst. This script has been edit for personal use. 
Please dont use it if you not understand.
-------------------------------------------------------------------------
