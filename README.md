## rtinst

#### 30 Second Guide

Ubuntu and Debian Seedbox Installation

Download and run setup (if logged in directly as root, do not need to use sudo)

	sudo bash -c "$(wget --no-check-certificate -qO - https://raw.githubusercontent.com/mrlongshen/rtinst/master/rtsetup)"

and then to run the main script, ([check the options you can use](https://github.com/arakasi72/rtinst/wiki/Guide#21-main-script-options)):

	sudo rtinst

It takes about 10 minutes to run, depending on your server setup. After you have run the script and everything is working, I suggest a reboot, the script does not automate this reboot, you need to do it manually using the reboot command.

[A detailed installation guide](https://github.com/arakasi72/rtinst/wiki/Installing-rtinst)

[A detailed user guide](https://github.com/arakasi72/rtinst/wiki/Guide)

**IMPORTANT: NOTE THE NEW SSH PORT AND MAKE SURE YOU CAN SSH INTO YOUR SERVER BEFORE CLOSING THE EXISTING SESSION**


It has been tested with clean installs of: 

	Ubuntu 16
	Debian 8
	Debian 9

Services that will be installed and configured are

	1. vsftpd - ftp server
	2. libtorrent/rtorrent
	3. rutorrent
	4. Nginx (webserver)
	5. autodl-irssi
	6. webmin (optional see section 3.7 in main guide)


[rtinst installation guide](https://github.com/arakasi72/rtinst/wiki/Installing-rtinst)

[Additional information on all the features](https://github.com/arakasi72/rtinst/wiki/Guide)

To see latest updates to the script go to [Change Log](https://github.com/arakasi72/rtinst/wiki/Change-Log)

-------------------------------------------------------------------------
