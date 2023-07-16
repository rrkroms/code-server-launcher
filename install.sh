#!/bin/bash
source rom_ui
CS_LAUNCHER=${PREFIX}/bin/codeserver
CS_SHORTCUT=${PREFIX}/bin/cs
STYLE_DIR=~/.roms/bash/rom_ui

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
help() {
    echo "
this is code-server launcher manager to help to install code-server and its accessories 
		
USAGE : $0 [OPTIONS]

OPTION 		MEANING
-i	 	install code-server launcher
-r 		remove  code-server launcher"
}
case $1 in
-i) create_launcher ;;
-r) remove_launcher $@ ;;
--help) help ;;
*) tell i "worng argument \n ${yellow} use ${0} --help" ;;
esac