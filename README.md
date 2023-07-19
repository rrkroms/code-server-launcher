>**DISCLAIMER:** THIS IS AN ALPHA/EXPERIMENTAL VERSION.
## support/Requirements
- ubuntu distro(`proot-distro`)
- proot-distro
- termux
- code-server

## setup

##### setup distro
- install `proot-distro` : `pkg update && pkg install proot-distro`
- install ubuntu distro : `proot-distro install ubuntu`

## setup launcher
- run `chmod -x ./install.sh` to make executable.
- run `./install.sh -i --apk` to install code-server web-viewer/browser 
- run `./install.sh -i --launcher` to install `code-server-launcher`
- run `./install.sh -r` to uninstall `code-server-launcher`(This command can't remove the code-server package and the linux distro)

## launcher option's usage
- run `./vscode.sh -s` to start code-server with code-server web viewer app
- run `./vscode.sh -q` to stop/kill code-server
