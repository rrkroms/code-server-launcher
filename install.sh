#!/bin/bash
source rom_ui
source roms_bash_plugin

CS_LAUNCHER=${PREFIX}/bin/codeserver
CS_SHORTCUT=${PREFIX}/bin/cs
STYLE_DIR=~/.roms/bash/rom_ui

cs_installer (){
	local os=$(uname -o) 
	set_var() {
		while [ -z "${VARIANT}" ]; do
			if [ ${os} == "Android" ] ; then
				tell a "${blue}Which type of ervairment do you want for code-server?"
				tell d "${yellow}1. proot ervairment (recommend) \n"
				tell d "${yellow}2. termux ervairment\n"
				read -p "select code-server' ervairment : " choice
				if [ "$choice" = "1" ]; then
					tell i "you are choose code-server proot base ervairment."
					VARIANT=proot
				elif [ "$choice" = "2" ] ; then
					tell i "you are choose code-server termux base package."
					VARIANT="termux"
				fi
			else 
				tell f "you have already linux environment."
				exit
			fi
			unset $choice
		done
	}
	distro_installer(){

		if [ ! -d $PREFIX/var/lib/proot-distro/installed-rootfs/ubuntu ] ; then
			pkg_installer proot-distro
			if proot-distro install ubuntu ;then
				status=("s" "successful." "0")
			else
   				status=("f" "faile!" "1")
			fi
			tell ${status[0]} "ubuntu installtion ${status[1]}" return ${status[2]}
		else
			tell s "proot distro alredy installed." return 0
		fi
	}
	cs_installer(){
		if ! proot-distro login ubuntu -- command -v code-server >/dev/null ; then
			tell i "installing code-server"
			if 	proot-distro login ubuntu -- apt update && proot-distro login ubuntu -- apt install code-server -y ; then 
				status=("s" "successful." "0")
			else
	   			status=("f" "faile!" "1")
			fi
			tell ${status[0]} "code-server installtion ${status[1]}" return ${status[2]}
		else
			tell s "code-server already installed."
		fi
	}
	set_var
	if [ $VARIANT == "proot" ]; then
		distro_installer && cs_installer
	elif [ $VARIANT == "termux" ] ; then
		tell i "install code-server installing"
		if apt install tur-repo && apt install code-server ; then
			status=("s" "successful." "0")
		else
			status=("f" "faile!" "1")
		fi
		tell ${status[0]} "code-server installtion ${status[1]}"
		return ${status[2]}
	fi
}

create_launcher() {
    cp vscode.sh ${CS_LAUNCHER}

    chmod 700 ${CS_LAUNCHER}
    [ -L ${CS_SHORTCUT} ] && rm -f ${CS_SHORTCUT}
    [ ! -f ${CS_SHORTCUT} ] && ln -s ${CS_LAUNCHER} ${CS_SHORTCUT} >/dev/null
    [ ! -d ~/.roms/bash/ ] && mkdir -p ~/.roms/bash/
    [ ! -e ${STYLE_DIR} ] && cp ./rom_ui ${STYLE_DIR}
}
remove_launcher() {
    if [[ -e ${CS_LAUNCHER} ]]; then
        [[ "$2" != "-y" ]] && ask i N "you want to remove code-server launcher" r && exit
        rm -rfv "${CS_LAUNCHER}" "${CS_SHORTCUT}" "${STYLE_DIR}" &&
        tell s "code-server launcher remove successfully"
    else
        tell f "code-server launcher dos'not exiest!"
    fi
}
apk_installer (){
	xdg-open app/code-server_1.apk
}
help() {
    echo "
this is code-server launcher manager to help to install code-server and its accessories 
		
USAGE : $0 [OPTIONS]

OPTION 		MEANING
-i	 	install code-server launcher
-r 		remove  code-server launcher

[i] sub-option

USAGE : $0 -i [SUB-OPTIONS]

--code-server   install code-server package and it's dependencies
--launcher	install code-server web-server launcher
--apk		install code-server web-server viewer app"
}
case $1 in
-i) [[ -n $2 && "$2" == "--launcher" ]] && create_launcher && exit || [[ -n $2 && "$2" == "--apk" ]] && apk_installer && exit || [[ -n $2 && "$2" == "--code-server" ]] && cs_installer && exit || [ -z "$2" ] && help && exit || [[ -n $2 ]] && tell i "worng argument \n ${yellow} use ${0} --help" ;;
-r) remove_launcher $@ ;;
--help) help ;;
*) tell i "worng argument \n ${yellow} use ${0} --help" ;;
esac