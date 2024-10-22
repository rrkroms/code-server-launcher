#!/bin/bash
source rom_ui
source roms_bash_plugin
CS_LAUNCHER=${PREFIX}/bin/cs-launcher
CS_SHORTCUT=${PREFIX}/bin/cs
STYLE_DIR=~/.roms/bash/rom_ui

installer() {
	local os=$(uname -o)
	set_var() {
		while [ -z "${VARIANT}" ]; do
			if [ ${os} == "Android" ]; then
				printf "${blue}Which type of ervairment do you want for code-server?\n"
				printf "${yellow}1. proot (recommend) \n"
				printf "${yellow}2. termux package\n"
				read -p "select code-server' ervairment : " choice
				if [ "$choice" = "1" ]; then
					printf "\nyou are choose code-server proot base ervairment.\n"
					VARIANT=proot
				elif [ "$choice" = "2" ]; then
					printf "you are choose code-server termux base package.\n"
					VARIANT="termux"
				fi
			else
				tell f "you have already linux environment."
				exit
			fi
			unset $choice
		done
	}
	proot_installer() {
		if [ ! -d $PREFIX/var/lib/proot-distro/installed-rootfs/ubuntu ]; then
			pkg_installer proot-distro
			if proot-distro install ubuntu; then
				status=("s" "successful." "0")
			else
				status=("f" "faile!" "1")
			fi
			tell ${status[0]} "ubuntu installtion ${status[1]}" return ${status[2]}
		else
			tell i "proot distro alredy installed." return 0
		fi
	}
	cs_installer() {
		if ! proot-distro login ubuntu -- command -v code-server >/dev/null; then
			tell i "installing code-server"
			if proot-distro login ubuntu -- apt update && proot-distro login ubuntu -- apt install code-server -y; then
				status=("s" "successful." "0")
			else
				status=("f" "faile!" "1")
			fi
			tell ${status[0]} "code-server installtion ${status[1]}" return ${status[2]}
		else
			tell i "code-server already installed"
		fi
	}
	set_var
	[ $VARIANT == "proot" ] && proot_installer && cs_installer
	if [ $VARIANT == "termux" ]; then
		tell i "install code-server installing"
		if apt install code-server; then
			status=("s" "successful." "0")
		else
			status=("f" "faile!" "1")
		fi
		tell ${status[0]} "code-server installtion ${status[1]}"
		return ${status[2]}
	fi
}
create_launcher() {
	cat >${CS_LAUNCHER} <<-EOF
		#!$PREFIX/bin/bash

			CHROOT_CODE_NAME=ubuntu
		    CHROOT_USER_NAME=ubuntu
		    CHROOT_NAME=ubuntu
		    CHROOT_DIR=/data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs/ubuntu
		    CHROOT_LAUNCHER=proot-distro
			CHROOT_LAUNCHER_COM="proot-distro login \${CHROOT_NAME} --"
			CFG_DIR=~/.roms/cs
			APK_PKG_NAME=\$(grep -oP '^package_name: \K(.*)' \$CFG_DIR/.config 2>/dev/null)
			DEFUALT_LAUNCHER_PKG_NAME="org.chromium.webapk.a18f37c7c4dc2dd10_v2"
			source ~/.roms/bash/rom_ui

			config(){
				
				set_cfg(){

					set_apn(){
						if [ ! -e \$CFG_DIR ] ; then 
							mkdir -p \$CFG_DIR/ && tell s "created configurantion DIRECTORY."
						fi
						while [ -z \$package ] ; do
						 	input d "inter apk package name: " "package"
						done
						[[ ! -z \$package && "\$package" == "\${APK_PKG_NAME}" ]] && tell f "APN(APK package name) already exiest" && exit

						if [ ! -z \${APK_PKG_NAME} ] ; then
							sed -i "s/^package_name:.*/package_name: \$package/" "\$CFG_DIR/.config" &&
							tell d "\${APK_PKG_NAME} >>> \$package"
						else
							echo "package_name: \$package" >> \$CFG_DIR/.config
							if [[ -z \${APK_PKG_NAME} && \$package == \$DEFUALT_LAUNCHER_PKG_NAME ]] ; then
								tell s "configure default APK package name."
							else
			    				tell s "added package name: \$package "
							fi
						fi
					}
					help(){
						echo "
						Require the APK Package Name (APN) to launch the code-server's viewer APK.

						USAGE: cs -cs [sub-option] [APN]
						
						sub-option 			meaning
						--set-default-apn		set default APN(APK Package Name)
						--set-apn			set custom APN 

						tip: add APN after "--set-apn" options
						"
					}
					if [[ \$# -ge 0 ]] ; then
						case \$1 in
							--set-default-apn) local package="\$DEFUALT_LAUNCHER_PKG_NAME" ; set_apn ;;
							--set-apn) local package="\$2" ; set_apn ;;
							--help) help;;
							*) tell i "worng argument use : cs -cs --help" ; exit ;;
						esac
					fi
				}

				reset (){
					if [[ \$# -eq 1 && "\$1" == "-crv" || \$# -eq 1 && "\$1" == "-cvr" || \$# -eq 2 && "\$@" == "-cr --verbose" ]] ; then
						local option="-rfv"
					elif [[ "\$1" == "-cr" && \$# -eq 1 ]] ; then
						local option="-rf"
					else
						tell i "usage: cs -c --help" ; return 1
					fi
					
					if [ -e ~/.roms/cs ] ;then
						rm "\$option" ~/.roms/cs &&
						tell s "configuration successfuly reset." && exit
					else
						tell f "configuration not exiest."
					fi
				}
				help(){
					echo " 
					cs-launcher [-c] or configuration sub-options.
					sub-option 	meaning
					s			configure APK Package Name(APK)
					r			reset configure files  | v, --verbose  view reset command progress
					v			view APN
					"
					exit
				}
				# case \$2 in 
				# --help ) help;;
				# esac
				case \$1 in
					*s) set_cfg \$2 \$3 ;;
					*r*) reset \$@ ;;
					*v) [ ! -z \${APK_PKG_NAME} ] && tell d "\${APK_PKG_NAME}" || tell f "APK Package Name not set.";;
					-c ) [[ ! -z "\$2" && "\$2" == "--help" ]] && help || tell i "usage: cs -c --help";;
					*) tell i "usage: cs -c --help"
				esac
			}
		start (){
			web(){
				# This line of code triggers the configuration function to set the APN default configuration if the APK Package Name (APN) does not exist in the config file.
				[ -z \${APK_PKG_NAME} ] && config -cs --set-default-apn && APK_PKG_NAME=\$(grep -oP '^package_name: \K(.*)' \$CFG_DIR/.config 2>/dev/null)

				local proces_name=node
				local tar_dir=/usr/lib/code-server/out/node/entry
				local servername=localhost:8080
				while true ; do
				local pid=\$(pgrep -f ".*\$proces_name.*\$tar_dir")
					if [[ -n \${pid} ]] ; then
						while true ; do
							if curl --head --silent --fail \${servername} 2> /dev/null ; then
								am start --user 0 -n \${APK_PKG_NAME}/org.chromium.webapk.shell_apk.h2o.H2OTransparentLauncherActivity
								break
							else
								[ "\$1" == "-v" ] && tell f "code-server not alive on \${servername}"
							fi
							sleep 2
						done
						break
					fi
				done
				unset pid
			}
			cs(){
				if [[ -e \${PREFIX}/bin/\${CHROOT_LAUNCHER} && -e \${CHROOT_DIR}/usr/bin/code-server ]] ; then
					tell i "launching code-server" 
					\${CHROOT_LAUNCHER_COM} code-server \$1
					# tell s "code-server successfully launched."
				else
					[ ! -e \$PREFIX/bin/\${CHROOT_LAUNCHER} ] &&
					tell f " proot ${CHROOT_NAME} not found" &&

					[ ! -e '${CHROOT_DIR}/bin/code-server' ] &&
					echo "${CHROOT_DIR}/bin/code-server"
					tell f "code-server not found in ${CHROOT_NAME} proot, maybe code-server not install in proot?"

				fi
			}
			\$@
		}

		stop (){
			taks_list=\$(pgrep -x node 2>/dev/null)
			[ ! -n \$task_list ] && echo "code-server not running in background" 
			pkill -x node
			exit
		}

		help(){
			echo " 
			The cs-launcher is a code-server launcher designed to make it easy to use code-server on Android or Termux machines.

			USAGE: cs [OPTIONS] [code-server's options]

			OPTIONS		MEANING

			-s  	 	start code-server
			\\\$2  	 	argumment for code-server (only work with -s/start option)
			-q		stop code-server
			-l 		launch code-server's application/browser
			-c		configuration
			-cr		reset configuration"
		}

		case \$1 in
			-q ) stop ;;
			-s ) start cs \$2 & start web ;;
			-l ) start web -v ;;
			-c*) config \$@;;
			--help ) help ;;
			*) tell d "usage: cs --help for help" ;;
		esac
EOF

 chmod 700 $CS_LAUNCHER
 [ -L ${CS_SHORTCUT} ] && rm -f ${CS_SHORTCUT}
 [ ! -f ${CS_SHORTCUT} ] && ln -s ${CS_LAUNCHER} ${CS_SHORTCUT} >/dev/null
 [ ! -d ~/.roms/bash/ ] && mkdir -p ~/.roms/bash/
 [ ! -e ${STYLE_DIR} ] && cp ./rom_ui ${STYLE_DIR}

 tell i "code-server launcher created."
}

remove_launcher() {
 if [[ -e ${CS_LAUNCHER} ]]; then
  [[ "$2" != "-y" ]] && ask i N "you want to remove code-server launcher" r && exit
  rm -rfv "${CS_LAUNCHER}" "${CS_SHORTCUT}" "${STYLE_DIR}" ~/.roms/cs &&
   tell s "code-server launcher remove successfully"
 else
  tell f "code-server launcher dos'not exiest!"
 fi
}

apk_installer() {
 if ! command -v xdg-open >/dev/null; then
  pkg_installer xdg-utils &&
   xdg-open app/code-server_1.apk
 else
  # for more info  goto: https://command-not-found.com/xdg-open
  xdg-open app/code-server_1.apk
 fi
}

help() {
 echo "
	Code-Server Launcher Manager helps you install Code-Server with its browser/application launcher.
		
USAGE : $0 [OPTION] [SUB-OPION]

OPTION    MEANING
-i        install code-server launcher
-r        remove  code-server launcher

[-i] sub-option
--launcher  install code-server web-server launcher
--apk       install code-server web-server viewer app"
}
[[ $# -ne "1" && $# -ne "2" ]] && help && exit
case $1 in
-i) [[ -n $2 && "$2" == "--launcher" ]] && create_launcher && exit || [[ -n $2 && "$2" == "--apk" ]] && apk_installer && exit || [ -z $2 ] && installer ;;
-r) remove_launcher $@ ;;
--help) help ;;
*) tell i "worng argument \n ${yellow} use ${0} --help" ;;
esac
