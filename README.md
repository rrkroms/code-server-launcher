code-server
----
this script/programme help to make easy to use code-server in android/termux.

## installtion

- step 1 
clone repo:
```
 git clone https://github.com/rrkroms/code-server.git
```
- step 2
install code-server luancher:
```
bash ./install.sh -i
```
- step 3 
install web-server apk/browser :
```
./install.sh -apk
```

## uninstalltion
>this command only remove code-server launcher( `cs`,`codeserver`) not a code-server packge.
```
bash ./install.sh -r
```
or
> remove manually from `bin parth`, here is example of termux:
```
rm -rf $RPEFIX/bin/cs $PREFIX/bin/codeserver
```

> Note : use -y as $3 for pre-confession for uninstalltion 
