#!/bin/bash
source rom_ui
DISTRO_DIR="${PREFIX}/var/lib/proot-distro/installed-rootfs/ubuntu"

web_launcher(){

local servername=localhost:8080 # default code-server's HTTP SERVER
       if curl --head --silent --fail ${servername} 2> /dev/null ; then 
	        am start --user 0 -n org.chromium.webapk.a18f37c7c4dc2dd10_v2/org.chromium.webapk.shell_apk.h2o.H2OTransparentLauncherActivity
		else 
			tell f "code-server is not running" &&
			tell d "Usage: '$0 -s' to start code-server"
		fi
}
start (){
if [[ -e ${PREFIX}/bin/proot-distro && -e ${DISTRO_DIR}/usr/bin/code-server ]] ; then
	tell i  "launching code-server by ubuntu proot!"
	proot-distro login ubuntu -- code-server $1 & sleep 7 ; am start --user 0 -n org.chromium.webapk.a18f37c7c4dc2dd10_v2/org.chromium.webapk.shell_apk.h2o.H2OTransparentLauncherActivity
	tell s "code-server successfully launched."
else
	[ ! -e $PREFIX/bin/proot-distro ] &&
	tell f "ERROR: The 'proot-distro' package is not installed. To run Ubuntu distro, please install it." && 
	tell d "USAGE: 'pkg install proot-ditro' to install proot-distro"
	echo
	[ ! -e ${DISTRO_DIR} ] &&
	tell f "ERROR: 'ubuntu' distro is not installed. To run code-server, please install it." &&
	tell d "USAGE: 'proot-distro install ubuntu' to install Ubuntu distro"
	echo
	[ ! -e ${DISTRO_DIR}/usr/bin/code-server ] &&
	tell f "ERROR: 'code-server' package is not installed on ubuntu distro." &&
	tell d "USAGE: proot-distro login ubuntu -- apt update && proot-distro login ubuntu -- apt install code-server \n     to install code-server in Ubuntu distro."
fi
}

stop (){
task_list="$(pgrep -x node 2>/dev/null)"
[ -z "$task_list" ] && tell f "code-server is not running in background" 
pkill -x node
}

case $1 in
-q ) stop ;;
-s ) start $2 ;;
-l ) web_launcher ;;
* )
 echo " 	thats programme help to easy to launch vsode server(code-server)
	launcher command:
	 Ex: [ -s|-u ] [\$2]
	\$2   argument/option for code-server
	-s 	start code-server
	-q	stop code-server
	-l	launch code-server web viewer app/browser" ;;
esac
