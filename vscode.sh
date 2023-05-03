start (){ curl --head --silent --fail "http://127.0.0.1:8080" 2> /dev/null &&
am start --user 0 -n org.chromium.webapk.a18f37c7c4dc2dd10_v2/org.chromium.webapk.shell_apk.h2o.H2OTransparentLauncherActivity
}
stop (){
pgrep -x node 2>/dev/null &&
echo "code-server not running in background"&&
exit 1 ||
pkill -x node
}
case $1  in
-q) stop;;
*) start ;;
esac
