# # code-server

**code-server** is a script/program designed to simplify the usage of code-server on Android or Termux environments.

## Installation

### Step 1: Clone Repository

Clone the repository by running the following command:

```bash
git clone https://github.com/rrkroms/code-server.git
```

### Step 2: Install code-server Launcher

Install the code-server launcher using the following command:

```bash
bash ./install.sh -i
```

### Step 3: Install Web Server APK/Browser

Install the web-server APK or browser by executing the following command:

```bash
./install.sh -apk
```

## Uninstallation

Please note that this command only removes the code-server launcher (`cs`, `codeserver`), not the code-server package itself.

```bash
bash ./install.sh -r
```

Alternatively, you can manually remove the launcher from the `bin` path. Below is an example for Termux:

```bash
rm -rf $RPEFIX/bin/cs $PREFIX/bin/codeserver
```

> **Note:** If you want to proceed with the uninstallation without any prompts, use `-y` as the third argument for pre-confirmation.

Feel free to use code-server for a seamless coding experience on your Android or Termux environment. Happy coding!
