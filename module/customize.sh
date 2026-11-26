#!/sbin/sh
SKIPUNZIP=1
ASH_STANDALONE=1

ui_print "- box4 共享版 v6.4（上游 main 基线，不含任何节点）"

if [ "$BOOTMODE" != true ] ; then
  abort "! 请在 Magisk / KernelSU / APatch 管理器中刷入"
fi
if [ "$KSU" = true ] && [ "$KSU_VER_CODE" -lt 10670 ] ; then
  abort "! 请先升级 KernelSU"
fi

if [ "$KSU" = true ] && [ "$KSU_VER_CODE" -lt 10683 ] ; then
  service_dir="/data/adb/ksu/service.d"
else
  service_dir="/data/adb/service.d"
fi
[ -d "$service_dir" ] || mkdir -p "$service_dir"

ui_print "- 解压文件"
unzip -qo "${ZIPFILE}" -x 'META-INF/*' -d "$MODPATH"

if [ -d /data/adb/box ] ; then
  ui_print "- 备份现有 /data/adb/box 为 /data/adb/box.bak"
  rm -rf /data/adb/box.bak
  cp -af /data/adb/box /data/adb/box.bak
fi

ui_print "- 停掉正在运行的旧内核"
for pid in $(pidof mihomo) ; do
  kill "${pid}" 2>/dev/null
done
for pid in $(pidof inotifyd) ; do
  if grep -q box.inotify /proc/${pid}/cmdline 2>/dev/null ; then
    kill "${pid}" 2>/dev/null
  fi
done
pid=$(cat /data/adb/box/run/webui.pid 2>/dev/null)
[ -n "$pid" ] && kill "$pid" 2>/dev/null
for pid in $(ps -A -o PID,ARGS 2>/dev/null | grep 'httpd -f -p 7895' | grep -v grep | awk '{print $1}') ; do
  kill "$pid" 2>/dev/null
done
sleep 1

ui_print "- 还原 /data/adb/box"
rm -rf /data/adb/box
mv "$MODPATH/box" /data/adb/box || abort "! 还原 /data/adb/box 失败"
mkdir -p /data/adb/box/run

ui_print "- 安装开机脚本到 ${service_dir}"
mv -f "$MODPATH/box4_service.sh" "$service_dir/"
mv -f "$MODPATH/box4_watchdog.sh" "$service_dir/"
mv -f "$MODPATH/box4_webui.sh" "$service_dir/"

# 唯一入口：/data/adb/box/box
mv -f "$MODPATH/box4-entry.sh" /data/adb/box/box

# 订阅只填一行
printf '%s\n' '# 把下面这行换成你的订阅链接，保存后执行： sh /data/adb/box/box sub' > /data/adb/box/sub.txt

# 首次启动保护：订阅还没填时不自启
touch /data/adb/box/manual

rm -f "$MODPATH/box4-entry.sh" "$MODPATH/customize.sh" "$MODPATH/box4_service.sh" "$MODPATH/box4_watchdog.sh" "$MODPATH/box4_webui.sh"

set_perm_recursive $MODPATH 0 0 0755 0644
set_perm_recursive /data/adb/box 0 0 0755 0644
set_perm_recursive /data/adb/box/scripts 0 0 0755 0755
set_perm_recursive /data/adb/box/bin 0 0 0755 0700
chmod 0755 /data/adb/box/box /data/adb/box/webroot/cgi-bin/api 2>/dev/null
chown -R 0:3005 /data/adb/box 2>/dev/null
set_perm "$service_dir/box4_service.sh" 0 0 0700
set_perm "$service_dir/box4_watchdog.sh" 0 0 0700
set_perm "$service_dir/box4_webui.sh" 0 0 0700

ui_print "- 完成。两个入口："
ui_print "  浏览器 http://127.0.0.1:7895   填订阅 / 开关代理"
ui_print "  命令行 sh /data/adb/box/box on|off|sub|status"
