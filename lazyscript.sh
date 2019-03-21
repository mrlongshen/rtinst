#!/bin/bash
# ruTorrent e(x)tras management by swizzin
# Script compiling by mrlongshen for personal use

function _intro() {
  whiptail --title "Lazy Scripts Manager" --msgbox "Welcome to Lazy Script Manager! Using this script you can choose to install and remove the plugins and themes for ruTorrent and many more.  Use the arrow keys to navigate, spacebar to toggle the currently selected item and enter to continue." 15 50
}

function _function() {
  function=$(whiptail --title "rtx" --menu "Choose an option:" --ok-button "Continue" --nocancel 12 50 7 \
               Plugins "" \
               Themes "" \
               UpdateOS "" \
               InstallQuota "" \
               InstallVnstat "" \
               TestNginx "" \
               ReloadNginx "" \
               InstallFileManager "" \
               SetDisk "" \
               InstallQuotaSpace "" \
               Exit "" 3>&1 1>&2 2>&3)

    if [[ $function == Plugins ]]; then
      _plugins
    elif [[ $function == Themes ]]; then
      _themes
	elif [[ $function == UpdateOS ]]; then
      _updateos
	elif [[ $function == InstallQuota ]]; then
      _installquota
	elif [[ $function == InstallVnstat ]]; then
      _installvnstat
	elif [[ $function == TestNginx ]]; then
      _testnginx
	elif [[ $function == ReloadNginx ]]; then
      _reloadnginx
	elif [[ $function == InstallFileManager ]]; then
      _installfilemanager
	elif [[ $function == SetDisk ]]; then
      _setdisk
	elif [[ $function == InstallQuotaSpace ]]; then
      _quotaspace
    elif [[ $function == Exit ]]; then
      exit 0
    fi
}

function _updateos() {
	apt update
}

function _installquota() {
	apt install quota
}

function _installvnstat() {
	apt install vnstat
}

function _testnginx() {
	nginx -t
}

function _reloadnginx() {
	systemctl reload nginx
}

function _installfilemanager() {
clear

# Checking if user is root
if [ "$(id -u)" != "0" ]; then
	echo
	echo "Sorry, this script must be run as root." 1>&2
	echo
	exit 1
fi

# Asking for the ruTorrent path folder
read -p "Please type your ruTorrent path folder: " -e -i /var/www/rutorrent rutorrent_path

# Installing dependencies
apt-get install subversion zip

cd /tmp

if [ `getconf LONG_BIT` = "64" ]
then
    wget -O rarlinux.tar.gz http://www.rarlab.com/rar/rarlinux-x64-5.5.0.tar.gz
else
    wget -O rarlinux.tar.gz http://www.rarlab.com/rar/rarlinux-5.5.0.tar.gz
fi

tar -xzvf rarlinux.tar.gz
rm rarlinux.tar.gz

mv -v rar/rar /usr/local/bin/rar
chmod 755 /usr/local/bin/rar

# Installing and configuring filemanager plugin
cd $rutorrent_path/plugins/
svn co https://github.com/nelu/rutorrent-thirdparty-plugins/trunk/filemanager

cat > $rutorrent_path/plugins/filemanager/conf.php << EOF
<?php

\$fm['tempdir'] = '/tmp';                // path were to store temporary data ; must be writable
\$fm['mkdperm'] = 755;           // default permission to set to new created directories

// set with fullpath to binary or leave empty
\$pathToExternals['rar'] = '$(which rar)';
\$pathToExternals['zip'] = '$(which zip)';
\$pathToExternals['unzip'] = '$(which unzip)';
\$pathToExternals['tar'] = '$(which tar)';
\$pathToExternals['bzip2'] = '$(which bzip2)';

// archive mangling, see archiver man page before editing

\$fm['archive']['types'] = array('rar', 'zip', 'tar', 'gzip', 'bzip2');

\$fm['archive']['compress'][0] = range(0, 5);
\$fm['archive']['compress'][1] = array('-0', '-1', '-9');
\$fm['archive']['compress'][2] = \$fm['archive']['compress'][3] = \$fm['archive']['compress'][4] = array(0);

?>
EOF

# Permissions for filemanager
chown -R www-data:www-data $rutorrent_path/plugins/filemanager
chmod -R 775 $rutorrent_path/plugins/filemanager/scripts

# End of the script
clear
echo
echo
echo -e "\033[0;32;148mInstallation done.\033[39m"

}

function _setdisk() {
echo "================================================================================="
echo "Disk Space MUST be in GB/TB - Do not attempt to add decimals in space settings,"
echo "Example - Good: 711GB OR 2TB, Example - Bad: 711.5GB OR 2.5TB"
echo "================================================================================="
echo
echo -n "Username: "
read username
echo "Quota size for user: (EX: 500GB): "
read SIZE
case $SIZE in
  *TB)
    QUOTASIZE=$(echo $SIZE|cut -d'T' -f1)
    DISKSIZE=$(($QUOTASIZE * 1024 * 1024 * 1024))
    setquota -u ${username} ${DISKSIZE} ${DISKSIZE} 0 0 -a
  ;;
  *GB)
    QUOTASIZE=$(echo $SIZE|cut -d'G' -f1)
    DISKSIZE=$(($QUOTASIZE * 1024 * 1024))
    setquota -u ${username} ${DISKSIZE} ${DISKSIZE} 0 0 -a
  ;;
  *MB)
    QUOTASIZE=$(echo $SIZE|cut -d'M' -f1)
                DISKSIZE=$(($QUOTASIZE * 1024))
                setquota -u ${username} ${DISKSIZE} ${DISKSIZE} 0 0 -a
  ;;
  *)
    echo "================================================================================="
    echo "Disk Space MUST be in GB/TB - Do not attempt to add deciamals in space settings,"
    echo "Example - Good: 711GB OR 2TB, Example - Bad: 711.5GB OR 2.5TB"
    echo "Exiting script, type bash $0 and try again"
    echo "=================================================================================";exit 0
  ;;
esac
}

function _quotaspace() {
clear

# Checking if user is root
if [ "$(id -u)" != "0" ]; then
	echo
	echo "Sorry, this script must be run as root." 1>&2
	echo
	exit 1
fi

# Asking for the ruTorrent path folder
read -p "Please type your ruTorrent Plugins path folder: " -e -i /var/www/rutorrent/plugins rutorrent_plugin_path


# Installing and configuring filemanager plugin
cd $rutorrent_plugin_path/plugins/
svn co https://github.com/nelu/rutorrent-thirdparty-plugins/tree/stable/filemanager


# Permissions for filemanager
chown -R www-data:www-data $rutorrent_plugin_path/plugins/filemanager
chmod -R 775 $rutorrent_plugin_path/plugins/filemanager/scripts

# End of the script
clear
echo
echo
echo -e "\033[0;32;148mInstallation done.\033[39m"

}



























function _plugins() {
  function=$(whiptail --title "rtx" --menu "Choose an option:" --ok-button "Continue" --nocancel 12 50 4 \
               Install "plugins" \
               Remove "plugins" \
               Back "" \
               Exit "" 3>&1 1>&2 2>&3)

    if [[ $function == Install ]]; then
      _itplugs
    elif [[ $function == Remove ]]; then
      _rmplugs
    elif [[ $function == Back ]]; then
      _function
    elif [[ $function == Exit ]]; then
      exit 0
    fi
}

function _themes() {
  function=$(whiptail --title "rtx" --menu "Choose an option:" --ok-button "Continue" --nocancel 12 50 4 \
               Install "themes" \
               Remove "themes" \
               Back "" \
               Exit "" 3>&1 1>&2 2>&3)

    if [[ $function == Install ]]; then
      _itthemes
    elif [[ $function == Remove ]]; then
      _rmthemes
    elif [[ $function == Back ]]; then
      _function
    elif [[ $function == Exit ]]; then
      exit 0
    fi
}

function _itplugs() {
  installa=()
  plugs=(_getdir _noty _noty2 _task autotools check_port chunks cookies cpuload create data datadir diskspace edit erasedata extratio extsearch feeds filedrop filemanager fileshare geoip history httprpc ipad loginmgr logoff lookat mediainfo mobile pausewebui ratio ratiocolor retrackers rpc rss rssurlrewrite rutracker_check scheduler screenshots seedingtime show_peers_like_wtorrent source spectrogram theme throttle tracklabels trafic unpack uploadeta xmpp)
  for i in "${plugs[@]}"; do
    plug=${i}
    if [[ ! -d /var/www/rutorrent/plugins/${plug} ]]; then
      installa+=("$i" '""')
    fi
  done
  whiptail --title "Choose Plugins" --checklist --noitem --separate-output "Make some choices:" 15 46 7 "${installa[@]}" 2>/tmp/results
  
  exitstatus=$?
  if [[ $exitstatus = "1" ]]; then
    _plugins
  fi

  readarray result < /tmp/results
  for i in "${result[@]}"; do
    result=$(echo $i)
    echo -e "Installing ${result}"
    cd /var/www/rutorrent/plugins
    case "$result" in
        _getdir|_noty|_noty2|_task|autotools|check_port|chunks|cookies|cpuload|create|data|datadir|diskspace|edit|erasedata|extratio|extsearch|feeds|filedrop|geoip|history|httprpc|ipad|loginmgr|lookat|mediainfo|ratio|retrackers|rpc|rss|rssurlrewrite|rutracker_check|scheduler|screenshots|seedingtime|show_peers_like_wtorrent|source|spectrogram|theme|throttle|tracklabels|trafic|unpack|uploadeta|xmpp)
        if [[ $result = "ipad" ]]; then
            if [[ -d /var/www/rutorrent/plugins/mobile ]]; then
                echo "iPad plugin is not compatible with mobile"
                continue
            fi
        fi
        svn co https://github.com/Novik/ruTorrent.git/trunk/plugins/${result} ${result}
        if [[ $result = "create" ]]; then
            sed -i 's/useExternal = false;/useExternal = "mktorrent";/' /var/www/rutorrent/plugins/create/conf.php
            sed -i 's/pathToCreatetorrent = '\'\''/pathToCreatetorrent = '\''\/usr\/bin\/mktorrent'\''/' /var/www/rutorrent/plugins/create/conf.php
        elif [[ $result = "spectrogram" ]]; then
            apt-get -y -q install sox > /dev/null 2>&1
            sed -i "s/\$pathToExternals\['sox'\] = ''/\$pathToExternals\['sox'\] = '\/usr\/bin\/sox'/g" /var/www/rutorrent/plugins/spectrogram/conf.php
        fi
        ;;
        filemanager)
        svn co https://github.com/nelu/rutorrent-thirdparty-plugins/trunk/filemanager >/dev/null 2>&1
        chmod -R +x /var/www/rutorrent/plugins/filemanager/scripts
cat >/var/www/rutorrent/plugins/filemanager/conf.php<<FMCONF
<?php

\$fm['tempdir'] = '/tmp';
\$fm['mkdperm'] = 755;

// set with fullpath to binary or leave empty
\$pathToExternals['rar'] = '$(which rar)';
\$pathToExternals['zip'] = '$(which zip)';
\$pathToExternals['unzip'] = '$(which unzip)';
\$pathToExternals['tar'] = '$(which tar)';


// archive mangling, see archiver man page before editing

\$fm['archive']['types'] = array('rar', 'zip', 'tar', 'gzip', 'bzip2');




\$fm['archive']['compress'][0] = range(0, 5);
\$fm['archive']['compress'][1] = array('-0', '-1', '-9');
\$fm['archive']['compress'][2] = \$fm['archive']['compress'][3] = \$fm['archive']['compress'][4] = array(0);




?>
FMCONF
        ;;
        fileshare)
        svn co https://github.com/nelu/rutorrent-thirdparty-plugins/trunk/fileshare >/dev/null 2>&1
        ln -s /var/www/rutorrent/plugins/fileshare/share.php /var/www/fancyindex/share.php >/dev/null 2>&1
        sed -i 's/$downloadpath .*/$downloadpath = $_SERVER['"'HTTP_HOST'"'] . '"'\/fancyindex\/share.php'"';/g' /var/www/rutorrent/plugins/fileshare/conf.php
        ;;
        #fileupload)
        #svn co https://github.com/nelu/rutorrent-thirdparty-plugins/trunk/fileupload >/dev/null 2>&1
        #;;
        logoff)
        wget -q https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/rutorrent-logoff/logoff-1.3.tar.gz
        tar xf logoff-1.3.tar.gz >/dev/null 2>&1
        rm -rf logoff-1.3.tar.gz
        ;;
        mobile)
        git clone https://github.com/xombiemp/rutorrentMobile.git mobile >/dev/null 2>&1
        rm -r /var/www/rutorrent/plugins/ipad
        ;;
        pausewebui)
        git clone https://github.com/Gyran/rutorrent-pausewebui.git pausewebui >/dev/null 2>&1
        ;;
        ratiocolor)
        svn co https://github.com/Gyran/rutorrent-ratiocolor.git/trunk ratiocolor >/dev/null 2>&1
        sed -i "s/changeWhat = \"cell-background\";/changeWhat = \"font\";/g" /var/www/rutorrent/plugins/ratiocolor/init.js
        ;;
    esac
    done
    chown -R www-data: /var/www/rutorrent/plugins
    /usr/local/bin/swizzin/php-fpm-cli -r 'opcache_reset();'
    rm /tmp/results
    _function
}

function _rmplugs() {
  removea=()
  plugs=(autotools checkport chunks cookies cpuload create data datadir diskspace edit erasedata extratio extsearch feeds filedrop filemanager fileshare fileupload geoip getdir history httprpc ipad loginmgr logoff lookat mediainfo mobile noty pausewebui ratio ratiocolor retrackers rpc rss rssurlrewrite rutracker_check scheduler screenshots seedingtime show_peers_like_wtorrent source spectrogram task theme throttle tracklabels trafic unpack uploadeta xmpp)
  for i in "${plugs[@]}"; do
    plug=${i}
    if [[ -d /var/www/rutorrent/plugins/$i ]]; then
      removea+=("$i" '""')
    fi
  done
  whiptail --title "Choose Plugins" --noitem --checklist --separate-output "Make some choices:" 15 46 7 "${removea[@]}" 2>/tmp/results

  exitstatus=$?
  if [[ $exitstatus = "1" ]]; then
    _plugins
  fi

    readarray result < /tmp/results
    for i in "${result[@]}"; do
      result=$(echo $i)
      echo -e "Removing ${result}"
      rm -rf /var/www/rutorrent/plugins/${result}
      if [[ $result = "fileshare" ]]; then
          rm -f /var/www/fancyindex/share.php
      fi
    done
  /usr/local/bin/swizzin/php-fpm-cli -r 'opcache_reset();'
  rm /tmp/results
  _function
}

function _itthemes() {
  installa=()
  themes=(Acid Agent34 Agent46 Blue club-QuickBox Dark DarkBetter Excel FlatUI_Dark FlatUI_Light FlatUI_Material MaterialDesign Oblivion OblivionBlue)
  for i in "${themes[@]}"; do
    plug=${i}
    if [[ ! -d /var/www/rutorrent/plugins/theme/themes/${i} ]]; then
      installa+=("$i" '""')
    fi
  done
  whiptail --title "Choose Themes" --checklist --noitem --separate-output "Make some choices:" 15 46 7 "${installa[@]}" 2>/tmp/results
  
  exitstatus=$?
  if [[ $exitstatus = "1" ]]; then
    _themes
  fi

  readarray result < /tmp/results
  for i in "${result[@]}"; do
    result=$(echo $i)
    echo -e "Installing ${result}"
    cd /var/www/rutorrent/plugins/theme/themes
    case "$result" in
        Acid|Blue|Dark|Excel|Oblivion)
        svn co https://github.com/Novik/ruTorrent.git/trunk/plugins/theme/themes/${result} ${result} >/dev/null 2>&1
        ;;
        Agent*|OblivionBlue)
        svn co https://github.com/ArtyumX/ruTorrent-Themes/trunk/${result} ${result} >/dev/null 2>&1
        ;;
        DarkBetter)
        git clone https://github.com/chocolatkey/DarkBetter.git ${result} >/dev/null 2>&1
        ;;
        club-QuickBox)
        git clone https://github.com/QuickBox/club-QuickBox.git ${result} >/dev/null 2>&1
        ;;
        FlatUI*)
        svn co https://github.com/exetico/FlatUI.git/trunk/${result} ${result} >/dev/null 2>&1
        ;;
        MaterialDesign)
        git clone https://github.com/phlooo/ruTorrent-MaterialDesign.git ${result} >/dev/null 2>&1
        ;;
    esac
    done
    chown -R www-data: /var/www/rutorrent/plugins
    /usr/local/bin/swizzin/php-fpm-cli -r 'opcache_reset();'
    rm /tmp/results
    _function
}

function _rmthemes() {
  removea=()
  themes=(Acid Agent34 Agent46 Blue club-QuickBox Dark Excel FlatUI_Dark FlatUI_Light FlatUI_Material MaterialDesign Oblivion OblivionBlue)
  for i in "${themes[@]}"; do
    themes=${i}
    if [[ -d /var/www/rutorrent/plugins/theme/themes/$i ]]; then
      removea+=("$i" '""')
    fi
  done
  whiptail --title "Choose Themes" --noitem --checklist --separate-output "Make some choices:" 15 46 7 "${removea[@]}" 2>/tmp/results

  exitstatus=$?
  if [[ $exitstatus = "1" ]]; then
    _themes
  fi

    readarray result < /tmp/results
    for i in "${result[@]}"; do
      result=$(echo $i)
      echo -e "Removing ${result}"
      rm -rf /var/www/rutorrent/plugins/theme/themes/${result}
    done
  /usr/local/bin/swizzin/php-fpm-cli -r 'opcache_reset();'
  rm /tmp/results
  _function
}

_intro
_function
