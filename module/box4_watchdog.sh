#!/system/bin/sh
# box4 守护：只按实际规则判断，不自动拉内核（避免"关了又被拉起来"）
#   manual 标记 → 撤规则后退出
#   无标记      → 内核在就保证转发跳转存在；内核没了才清规则
#   额外：重启/切网后 netd 可能清掉策略路由表，这里每轮自检并补回
BOX=/data/adb/box
SCRIPTS=$BOX/scripts

MARK_VALUE=20
TABLE_ID=2025
[ -f "$SCRIPTS/tproxy.conf" ] && . "$SCRIPTS/tproxy.conf" 2>/dev/null

has_rules() {
  iptables -w 100 -t mangle -S PREROUTING 2>/dev/null | grep -q PROXY_PREROUTING
}

ensure_route() {
  # 策略路由：(fw)mark → table TABLE_ID → local default dev lo
  ip route show table "$TABLE_ID" 2>/dev/null | grep -q "dev lo" || {
    ip route add local 0.0.0.0/0 dev lo table "$TABLE_ID" 2>/dev/null
  }
  ip rule show 2>/dev/null | grep -q "fwmark 0x$(printf '%x' "$MARK_VALUE")" || {
    ip rule add fwmark "$MARK_VALUE" table "$TABLE_ID" pref "$TABLE_ID" 2>/dev/null
  }
}

while true ; do
  if [ -f $BOX/manual ] ; then
    $SCRIPTS/box.tproxy -d "$SCRIPTS" stop >/dev/null 2>&1
    exit 0
  fi

  if pidof mihomo >/dev/null 2>&1 ; then
    if has_rules ; then
      ensure_route
    else
      $SCRIPTS/box.tproxy -d "$SCRIPTS" start >/dev/null 2>&1
      ensure_route
    fi
  else
    has_rules && $SCRIPTS/box.tproxy -d "$SCRIPTS" stop >/dev/null 2>&1
  fi

  # 设置页挂了就拉回来（7895）
  ps -A -o PID,ARGS 2>/dev/null | grep -q "httpd -f -p 7895" || sh $BOX/box webui on >/dev/null 2>&1

  sleep 15
done
