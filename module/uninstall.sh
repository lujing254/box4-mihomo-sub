#!/system/bin/sh
# 卸载时清掉开机脚本、进程和上游链名的 iptables / ip rule 残留
for d in /data/adb/service.d /data/adb/ksu/service.d /data/adb/ap/service.d ; do
  rm -f "$d/box4_service.sh" "$d/box4_watchdog.sh" "$d/box4_webui.sh"
done

p=$(cat /data/adb/box/run/webui.pid 2>/dev/null)
[ -n "$p" ] && kill "$p" 2>/dev/null
for q in $(ps -A -o PID,ARGS 2>/dev/null | grep 'httpd -f -p 7895' | grep -v grep | awk '{print $1}') ; do
  kill "$q" 2>/dev/null
done
for q in $(ps -A -o PID,ARGS 2>/dev/null | grep box4_watchdog | grep -v grep | awk '{print $1}') ; do
  kill -9 "$q" 2>/dev/null
done
for q in $(pidof mihomo) ; do kill -9 "$q" 2>/dev/null ; done

iptables -t mangle -D PREROUTING -j PROXY_PREROUTING 2>/dev/null
iptables -t mangle -D OUTPUT -j PROXY_OUTPUT 2>/dev/null
iptables -t mangle -D PREROUTING -p tcp -m socket -j DIVERT 2>/dev/null
iptables -t mangle -D OUTPUT -p tcp -m socket -j DIVERT 2>/dev/null
iptables -t nat -D PREROUTING -j DNS_HIJACK_PRE 2>/dev/null
iptables -t nat -D OUTPUT -j DNS_HIJACK_OUT 2>/dev/null

for c in PROXY_PREROUTING PROXY_OUTPUT DIVERT PROXY_IP BYPASS_IP BYPASS_INTERFACE \
         PROXY_INTERFACE DNS_HIJACK_PRE DNS_HIJACK_OUT APP_CHAIN MAC_CHAIN \
         BOX_LOCAL BOX_EXTERNAL LOCAL_IP_V4 LOCAL_IP_V6 CLASH_DNS_LOCAL CLASH_DNS_EXTERNAL ; do
  iptables -t mangle -F "$c" 2>/dev/null
  iptables -t mangle -X "$c" 2>/dev/null
  iptables -t nat -F "$c" 2>/dev/null
  iptables -t nat -X "$c" 2>/dev/null
done

ip rule del fwmark 0x14 lookup 2025 2>/dev/null
ip rule del fwmark 0x14/0xffffffff lookup 2025 2>/dev/null
ip route flush table 2025 2>/dev/null
