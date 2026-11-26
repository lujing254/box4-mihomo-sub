#!/system/bin/sh
# box4 订阅设置页面：开机后自动拉起（只监听 127.0.0.1:7895）
until [ "$(getprop sys.boot_completed)" = "1" ] ; do
  sleep 3
done
sleep 5
sh /data/adb/box/box webui on >/dev/null 2>&1
