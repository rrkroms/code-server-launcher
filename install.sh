#!/bin/bash
source rom_ui
CS_LAUNCHER=${PREFIX}/bin/codeserver
CS_SHORTCUT=${PREFIX}/bin/cs
STYLE_DIR=~/.roms/bash/rom_ui

create_launcher(){
cat > ${CS_LAUNCHER} <<-EOF
#!/$PREFIX/bin/bash -e
if [[ "\$1" == "-"*"k"* ]] ; then
	CHROOT_CODE_NAME=kali
	CHROOT_USER_NAME=kali
	CHROOT_NAME="kali linux"
	CHROOT_DIR=/data/data/com.termux/files//home/kali-arm64
	CHROOT_LAUNCHER="nh"
	CHROOT_LAUNCHER_COM=nh
else
   if	[[ "\$1" == "-"*"u"* ]] ; then
	CHROOT_CODE_NAME=ubuntu
        CHROOT_USER_NAME=ubuntu
        CHROOT_NAME=ubuntu
        CHROOT_DIR=/data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs/ubuntu
        CHROOT_LAUNCHER=proot-distro
	CHROOT_LAUNCHER_COM="proot-distro login \${CHROOT_NAME} --"
   fi
fi

source ~/.roms/bash/rom_ui

web_launcher(){

local servername=localhost:8080
        curl --head --silent --fail \${servername} 2> /dev/null &&
        am start --user 0 -n org.chromium.webapk.a18f37c7c4dc2dd10_v2/org.chromium.webapk.shell_apk.h2o.H2OTransparentLauncherActivity ||
		tell f "code-server not running"

}
start (){
echo "$CHROOT_NAME $CHROOT_LAUNCHER"
if [[ -e \${PREFIX}/bin/\${CHROOT_LAUNCHER} && -e \${CHROOT_DIR}/usr/bin/code-server ]] ; then
	tell t "launching code-server by ${CHROOT_NAME} proot!"
	\${CHROOT_LAUNCHER_COM} code-server \$2 & sleep 7 ; am start --user 0 -n org.chromium.webapk.a18f37c7c4dc2dd10_v2/org.chromium.webapk.shell_apk.h2o.H2OTransparentLauncherActivity
	tell s "code-server successfully launched."
else
	[ ! -e \$PREFIX/bin/\${CHROOT_LAUNCHER} ] &&
	tell f " proot ${CHROOT_NAME} not exit" &&

	[ ! -e '${CHROOT_DIR}/bin/code-server' ] &&
	echo "${CHROOT_DIR}/bin/code-server"
	tell f "code-server not found in ${CHROOT_NAME} proot, maybe code-server not install in proot?"

fi
}

stop (){
taks_list=\$(pgrep -x node 2>/dev/null)
[ ! -n \$task_list ] && echo "code-server not running in background" 
pkill -x node
}

case \$1 in
*q* ) stop ;;
*s* ) start ;;
-l ) web_launcher ;;
* )
 echo " 
this programme help to easy to launch vsode server(code-server)

USAGE: \$0 [OPTIONS] [code-server's options]

OPTIONS		MEANING

-u 		use ubuntu proot
-k 		use kali linux proot
\\\$3  	argumment for code-server
-s  	start code-server
-q		stop code-server
-l 		launch server app/browser";;
esac
EOF

chmod 700 $CS_LAUNCHER
    [ -L ${CS_SHORTCUT} ] && rm -f ${CS_SHORTCUT} 
	[ ! -f ${CS_SHORTCUT} ] && ln -s ${CS_LAUNCHER} ${CS_SHORTCUT} >/dev/null
    [ ! -d ~/.roms/bash/ ] && mkdir -p ~/.roms/bash/
    [ ! -e ${STYLE_DIR} ] && cp ./rom_ui ${STYLE_DIR}
}
remove_launcher(){
if [[ -e ${CS_LAUNCHER} ]] ; then
	[[ "$2" != "-y" ]] && ask i N "you want to remove code-server launcher" r && exit 
		rm -rfv "${CS_LAUNCHER}" "${CS_SHORTCUT}" "${STYLE_DIR}" &&
			tell s "code-server launcher remove successfully"
else
	tell f "code-server launcher dos'not exiest!"
fi
}
help(){
	echo "
this is code-server launcher manager to help to launcher code-server
		
USAGE : $0 [OPTIONS]

OPTION 		MEANING
-i	 	install code-server launcher
-r 		remove  code-server launcher"
}
[[ $# -ne "1" && $# -ne "2" ]] && help && exit
	case $1 in
		-i) create_launcher ;;
		-r) remove_launcher $@ ;;
		--help) help ;;
		*) tell i "worng argument \n ${yellow} use ${0} --help" 
	esac