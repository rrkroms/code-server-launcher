>**DISCLAIMER:** THIS IS AN ALPHA/EXPERIMENTAL VERSION.
## support/Requirements
- ubuntu distro or kali-linux (`proot-distro`)
- proot-distro
- termux

## Installtation

### Setup distro
- install proot-distro package : `pkg update && pkg install proot-distro`
> if you are kali linux user, then skip proot-distro installation.

**Setup unbuntu** 
- install ubuntu distro : `proot-distro install ubuntu`

**Setup kali-linux**
- install kali linux: https://www.kali.org/docs/nethunter/nethunter-rootless

### Setup code-server
- to install code-server for ubuntu, execute this command in `termux`  : 

```
proot-distro login ubuntu -- apt update && proot-distro login ubuntu -- apt install code-server
```

- kali linux's user run this command in kali linux terminal :
```
apt update && apt install code-server
```

### Setup launcher
- `install` code-server browser [apk](app/code-server_1.apk).
- run `chmod -x ./code.sh` to make executable.

## Usage

| options | usage | work/meaning |
| ------ | ------ | ------ |
| -s | ./vscode.sh -s[distro-option] or -[distro-option]s | start code-server on selected proot distro |
| -q | ./vscode.sh -q | stop/kill code-server |
| -k | ./vscode.sh -ks or -sk | set `kali linux` distro for code-sever |
| -u | ./vscode.sh -us or -su | set `ubuntu` distro for code-server |
| -l | ./vscode.sh -l | launch code-sever web viewer app/browser |
- to run code-server simply, use distro-option `-u` or `-k` with `-s` start-option.
example: for ubuntu, usage `./vscode.sh -us ` or `./vscode.sh -su`
         for kali linux usage `vscode.sh` -uk` or `./vscode,sh` -ku`

- to stop code-server simply, usage `./vscode.sh -q`.
- to open code-server web-viewer simply, usage `./vscode.sh -l`.