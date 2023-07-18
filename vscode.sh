#!/bin/bash
source rom_ui

if [[ "$1" == "-"*"k"* ]] ; then
	CHROOT_CODE_NAME=kali
	CHROOT_USER_NAME=kali
	CHROOT_NAME="kali linux"
	CHROOT_DIR=/data/data/com.termux/files//home/kali-arm64
	CHROOT_LAUNCHER="nh"
	CHROOT_LAUNCHER_COM=nh
else
   if	[[ "$1" == "-"*"u"* ]] ; then
	CHROOT_CODE_NAME=ubuntu
        CHROOT_USER_NAME=ubuntu
        CHROOT_NAME=ubuntu
        CHROOT_DIR=/data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs/ubuntu
        CHROOT_LAUNCHER=proot-distro
	CHROOT_LAUNCHER_COM="proot-distro login ${CHROOT_NAME} --"
   fi
fi

start (){
if [[ -e ${PREFIX}/bin/${CHROOT_LAUNCHER} && -e ${CHROOT_DIR}/usr/bin/code-server ]] ; then
	tell i "launching code-server by ${CHROOT_NAME} proot!"
	${CHROOT_LAUNCHER_COM} code-server $2 & sleep 7 ; am start --user 0 -n org.chromium.webapk.a18f37c7c4dc2dd10_v2/org.chromium.webapk.shell_apk.h2o.H2OTransparentLauncherActivity
	tell s "code-server successfully launched."
else
	[ ! -e $PREFIX/bin/{$CHROOT_LAUNCHER} ] &&
	tell f " proot ${CHROOT_NAME} not found"

	[ ! -e '${CHROOT_DIR}/bin/code-server' ] &&
	tell f "code-server not found in ${CHROOT_NAME} proot, maybe code-server not install in proot?"

fi
}

stop (){
task_list="$(pgrep -x node 2>/dev/null)"
[ -z "$task_list" ] && tell f "code-server not running in background" 
pkill -x node
}

case $1 in
*q* ) stop ;;
*s* ) start ;;
* )
 echo " 	thats programme help to easy to launch vsode server(code-server)
	launcher command:
	 Ex: [ -ku|-su|-us|-uk|-s|-q ] [\$3]
	\$3    argument/option for code-server
	-s 	start code-server
	-q	stop code-server
	-u 	use ubuntu proot
	-k 	use kali linux proot" ;;
esac
