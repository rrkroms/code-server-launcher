#!/bin/bash
source rom_ui
source roms_bash_plugin

if [[ "$1" == "-"*"k"* ]]; then
	get_arch
	DISTRO_NAME="kali linux"
	DISTRO_DIR=/data/data/com.termux/files//home/kali-${SYS_ARCH}
	DISTRO_LAUNCHER="nh"
	DISTRO_LAUNCHER_COM=nh
	SOLVE_DISTRO="Follow: README.md file to install kali linux with setup for vscode launcher."
	SOLVE_CODE_SERVER="Usage: 'nh apt update && nh apt install code-server' to install code-srever on ${DISTRO_NAME} distro."
elif [[ "$1" == "-"*"u"* ]]; then
	DISTRO_NAME=ubuntu
	DISTRO_DIR=${PREFIX}/var/lib/proot-distro/installed-rootfs/ubuntu
	DISTRO_LAUNCHER=proot-distro
	DISTRO_LAUNCHER_COM="proot-distro login ${DISTRO_NAME} --"
	SOLVE_DISTRO='Usage: `proot-distro install ubuntu` to install ${DISTRO_NAME}'
	SOLVE_CODE_SERVER='Usage: `proot-distro login ubuntu -- apt update && proot-distro login ubuntu -- apt install code-server` \n     to install code-server in Ubuntu distro.'
elif [[ "$1" == "-s" ]] ; then
	tell f "please specifying distro option:"
	echo "Usage: $0 [ -sk|-ks|-us|-su ]
	option		meaning
	u		ubuntu
	k		kali"
fi

web_launcher(){

	local servername=localhost:8080 # default code-server's HTTP SERVER
    curl --head --silent --fail ${servername} 2> /dev/null &&
    am start --user 0 -n org.chromium.webapk.a18f37c7c4dc2dd10_v2/org.chromium.webapk.shell_apk.h2o.H2OTransparentLauncherActivity ||
	tell f "code-server is not running" &&
	tell d "Usage: '$0 -s' to start code-server"
}

start() {
	if [[ -e ${PREFIX}/bin/${DISTRO_LAUNCHER} && -e ${DISTRO_DIR}/usr/bin/code-server ]]; then
		tell i "launching code-server by ${DISTRO_NAME} proot!"
		${DISTRO_LAUNCHER_COM} code-server $1 & sleep 7 ; am start --user 0 -n org.chromium.webapk.a18f37c7c4dc2dd10_v2/org.chromium.webapk.shell_apk.h2o.H2OTransparentLauncherActivity
		tell s "code-server successfully launched."
	else
		[[ "${DISTRO_LAUNCHER}" == "proot-distro" && ! -e ${PREFIX}/bin/proot-distro ]] &&
			tell f "Error: The 'proot-distro' package is not installed. To run ${DISTRO_NAME} distro, please install it." &&
			tell d "Usage: 'pkg install proot-ditro' to install proot-distro \n" && exit
		
		[ ! -e ${DISTRO_DIR} ] &&
			tell f "Error: '${DISTRO_NAME}' distro is not installed. To run code-server, please install it." &&
			tell d "${SOLVE_DISTRO} \n" && exit
		
		[[ -e ${DISTRO_DIR} && ! -e ${DISTRO_DIR}/usr/bin/code-server ]] &&
			tell f "Error: 'code-server' package is not installed on ${DISTRO_NAME} distro." &&
			tell d "${SOLVE_CODE_SERVER} \n" && exit
	fi
}

stop() {
	task_list="$(pgrep -x node 2>/dev/null)"
	[ -z "$task_list" ] && tell f "code-server is not running in background"
	pkill -x node
}

case $1 in
-*q*) stop ;;
-*s*) start $2;;
-l ) web_launcher ;;
*)
	echo " 	thats programme help to easy to launch vscode server(code-server)
	launcher command:
	 Ex: [ -ku|-su|-us|-uk|-s|-q|-l ] [\$2]
	\$2    argument/option for code-server
	-s 	start code-server 
	-q	stop code-server
	-u 	use ubuntu proot
	-k 	use kali linux proot
	-l	launch code-server web viewer app/browser"
	;;
esac
