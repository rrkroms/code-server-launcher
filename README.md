>**DISCLAIMER:** THIS IS AN ALPHA/EXPERIMENTAL VERSION.
## support/Requirements
- ubuntu distro(`proot-distro`)
- proot-distro
- termux

## setup

##### setup distro
- install `proot-distro` : `pkg update && pkg install proot-distro`
- install ubuntu distro : `proot-distro install ubuntu`

## setup launcher
- `install` code-server browser [apk](app/code-server_1.apk).
- run `chmod -x ./code.sh` to make executable.

## usage
- run `./vscode.sh -s` to start code-server with code-server web viewer app
- run `./vscode.sh -q` to stop/kill code-server
