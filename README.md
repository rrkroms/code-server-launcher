>**DISCLAIMER:** THIS IS AN ALPHA/EXPERIMENTAL VERSION.
## support/Requirements
- ubuntu distro or kali-linux (`proot-distro`)
- proot-distro
- termux
- 
## setup
##### setup distro
- install proot-distro : `pkg update && pkg install proot-distro`
- install ubuntu distro : `proot-distro install ubuntu`
- install kali linux: https://www.kali.org/docs/nethunter/nethunter-rootless

##### setup launcher
- `install` code-server browser [apk](app/code-server_1.apk).
- run `chmod -x ./code.sh` to make executable.

##### setup kali-linux
- kali linux's proot start script move at `termux` home's directory as `kali-arm64` 
- bind `termux`'s `bin` folder to kali linux proot: add `-b /data/data/com.termux/files` in start script's proot command section. (start script in termux's bin directory)

## usage

| options | usage | work/meaning |
| ------ | ------ | ------ |
| -s | ./vscode.sh -s[distro-option] or -[distro-option]s | start code-server on selected proot distro |
| -q | ./vscode.sh -q | stop/kill code-server |
| -k | ./vscode.sh -ks or -sk | set `kali linux` distro for code-sever |
| -u | ./vscode.sh -us or -su | set `ubuntu` distro for code-server |

- to run code-server simply, use distro-option `-u` or `-k` with `-s` start-option.
example: for ubuntu, usage `./vscode.sh -us ` or `./vscode.sh -su`
         for kali linux usage `vscode.sh` -uk` or `./vscode,sh` -ku`

- to stop code-server simply, usage `./vscode.sh -q`.
