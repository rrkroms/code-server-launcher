<div align="center">
  <!-- [Quickstart](#quickstart) | [usage](#usage) | [Why luancher](# whay-launcher)  -->
  <h1>
  code-server launcher
  </h1>
</div>

**code-server-launcher** is a command line script/program designed to simplify the usage of code-server on Android or Termux environments.

## 1: Setup code-server Launcher Manager

### 1.1: Clone Repository

Clone the repository by running the following command:

```bash
git clone https://github.com/rrkroms/code-server.git
```

> Open a terminal in the cloned repository and follow the instructions.

### 1.2: Make File Executable

```bash
chmod +x install.sh
```

Alternatively, you can use the installer script without making it executable by adding `bash` before `./install.sh` every time you use it:

```bash
bash ./install.sh
```

## 2. Installation

### 2.1: Install code-server Package

The installer has an automated code-server installation process. You just need to choose the environment for code-server.

If installation fails, visit the code-server official website [coder.com](https://coder.com/docs/code-server/latest/install).

> If you have already installed code-server in Termux or proot-distro (Ubuntu distro), you can skip the code-server installation part and proceed to the launcher installation part.

#### Step 1: To install code-server, run the following command:

```bash
./install.sh -i
```

Output:
```
~/code-server $ ./install.sh -i
Which type of environment do you want for code-server?
1. proot (recommended)
2. termux package
Select code-server's environment:
```

#### Step 2: Select environment for code-server

Here is the working summary of each option:

- `proot`: In proot environment, first install a Linux distro (Ubuntu) and then install code-server within the Ubuntu distro.

- `termux package`: In Termux, install the Termux variant of code-server. **Note: [known issues](https://coder.com/docs/code-server/latest/termux#known-issues) with code-server's Termux variant.**

> Tips: We recommend the `proot` environment because it provides a complete Linux environment.

  For more information about Termux's variant, please visit the official [website](https://coder.com/docs/code-server/latest/termux).


### 2.2: Install Web-Server Browser Launcher

Install the code-server launcher using the following command:

```bash
./install.sh -i --launcher
```

### 2.3: Install Web-Server Browser APK

Install the web-server APK or browser by executing the following command:

```bash
./install.sh -i --apk
```
## 3: Usage

### 3.1: option's chat

| option | long-option | work/meaning | usage |
| ------ | ------ | ------ | ------ |
| s | | start code-server with cs-viewer | cs -s |
| l | | launch code-server viwer| cs -l |
| c | | configure cs-launcher | cs -c[sub-option] |

#### 3.1.1: configuration sub-options
| option | long-option | work/meaning | usage |
| ------ | ------ | ------ | ------ |
| r | | reset/remove configuration | cs -cr |
| s | | set APN | cs -cs |
| v | | view APN | cs -cv] |

### 3.2: Configuration

Configure cs-launcher before using it. If you execute the launch command of the code-server viewer, cs-launcher will configure the default configuration.

#### 3.2.1 set configuration

*Q.: What is APN?*
*Ans.: APN stands for APK Package Name. It helps to launch the code-server viewer in Android.*

To configure CS Launcher, simply run the following command: `cs -cs [sub-option]`
Sub-options:
  - `--set-default-apn` : Set default APN 
  - `--set-apn` : Set custom APN

To set default APN configuration, simply use the `--set-default-apn` sub-option:
```bash
cs -cs --set-default-apn
```

If you have other APN or APK, then use the `--set-apn` sub-option:
```bash
cs -cs --set-apn [APN]
```
#### 3.2.2: reset/remove configuration
 
 to reset/remove condiguration simply use the `r` sub-option with `-c`:
 ```bash
 cs -cr
 ```
 Alternatively, you can reset the configuration by deleting the "configuration" directory.
 ```
 rm -rf ~/.roms/cs
 ```

### 3.3: start/stop code-server & web viewer

To run code-server with CS Launcher, simply execute the following command:
```bash
cs -s
```
This command will run code-server and then launch the default code-server viewer.

to stop code-server , simply execut the following command:
```bash
cs -q
```

To launch the default code-server viewer app, run the following command:
```bash
cs -l
```

## 4: Uninstallation

Please note that this command only removes the code-server launcher (`cs`, `codeserver`), not the code-server package itself.

```bash
bash ./install.sh -r
```

Alternatively, you can manually remove the launcher from the `bin` path. Below is an example for Termux:

```bash
rm -rf $RPEFIX/bin/cs $PREFIX/bin/codeserver ~/.roms/cs
```

> **Note:** If you want to proceed with the uninstallation without any prompts, use `-y` as the third argument for pre-confirmation.

##### 5: tools/repo

###### 5.1: third-party
- [code-server](https://github.com/coder/code-server)
- [proot-distro](https://github.com/termux/proot-distro)

###### 5.2 own/official
- ROMs-ui(private repo)
- ROMs-bash-addon(private repo)
