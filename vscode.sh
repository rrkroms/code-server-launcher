#!/bin/bash
source rom_ui
start (){
if [[ -e ${PREFIX}/bin/proot-distro && -e /data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs/ubuntu/usr/bin/code-server ]] ; then
	tell i "launching code-server by ubuntu proot!"
	proot-distro login ubuntu -- code-server $2 & sleep 7 ; am start --user 0 -n org.chromium.webapk.a18f37c7c4dc2dd10_v2/org.chromium.webapk.shell_apk.h2o.H2OTransparentLauncherActivity
	tell s "code-server successfully launched."
else
	[ ! -e $PREFIX/bin/proot-distro ] &&
	tell f " proot ${CHROOT_NAME} not exit" &&

	[ ! -e '${CHROOT_DIR}/bin/code-server' ] &&
	tell f "code-server not found in ubuntu proot, maybe code-server not install in proot?"

fi
}

stop (){
task_list="$(pgrep -x node 2>/dev/null)"
[ -z "$task_list" ] && tell f "code-server not running in background" 
pkill -x node
}

case $1 in
-q ) stop ;;
-s ) start ;;
* )
 echo " 	thats programme help to easy to launch vsode server(code-server)
	launcher command:
	 Ex: [ -s|-u ] [\$3]
	\$3    argument/option for code-server
	-s 	start code-server
	-q	stop code-server" ;;
esac
