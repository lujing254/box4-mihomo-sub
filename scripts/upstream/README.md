# scripts/upstream

上游基线脚本（`box.tproxy`、`box.service`、`box.config`、`start.sh`、`box.inotify`、`net.inotify`、`ctr.inotify`、`ctr.utils`、`tproxy.conf`）是
[CHIZI-0618/box4magisk](https://github.com/CHIZI-0618/box4magisk) main 分支的代码（`SCRIPT_VERSION=v26.04.07`），GPL-3.0。

为了不与上游重复维护，本仓库不重复分发这些文件，刷机包里用的就是上游原版（只改了三处）：

1. `tproxy.conf`：`PROXY_MOBILE` / `PROXY_WIFI` / `PROXY_HOTSPOT` / `PROXY_USB` 默认全开
2. `tproxy.conf`：`HOTSPOT_INTERFACE="ap+"`（适配本机热点接口名）
3. `tproxy.conf`：`DNS_HIJACK_ENABLE=2`（REDIRECT 53 → 1053，App DNS 才走 mihomo fake-ip）

需要自己构建刷机包时，从上游取这些文件放进模块的 `box/scripts/` 即可。
