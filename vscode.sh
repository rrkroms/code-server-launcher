#!/bin/bash
DISTRO_DIR="${PREFIX}/var/lib/proot-distro/installed-rootfs/ubuntu"

start (){
if [[ -e ${PREFIX}/bin/proot-distro && -e ${DISTRO_DIR}/usr/bin/code-server ]] ; then
	echo  "launching code-server by ubuntu proot!"
	proot-distro login ubuntu -- code-server $2 & sleep 7 ; am start --user 0 -n org.chromium.webapk.a18f37c7c4dc2dd10_v2/org.chromium.webapk.shell_apk.h2o.H2OTransparentLauncherActivity
	echo "code-server successfully launched."
else
	[ ! -e $PREFIX/bin/proot-distro ] &&
	echo "proot-distro not exitestt"

	[ ! -e ${DISTRO_DIR} ] &&
	echo " ubuntu distro not found"

	[ ! -e ${DISTRO_DIR}/usr/bin/code-server ] &&
	echo "code-server not found, maybe code-server not install in ubuntu distro?"

fi
}

stop (){
task_list="$(pgrep -x node 2>/dev/null)"
[ -z "$task_list" ] && echo "code-server not running in background" 
pkill -x node
}

case $1 in
-q ) stop ;;
-s ) start ;;
* )
 echo " 	thats programme help to easy to launch vsode server(code-server)
	launcher command:
	 Ex: [ -s|-u ] [\$3]
	\$3     argument/option for code-server
	-s 	start code-server
	-q	stop code-server" ;;
esac
