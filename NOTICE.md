# NOTICE / 第三方组件与来源

本仓库是**二次整理**，不是原创项目。以下组件随包分发或直接构成运行逻辑，版权归原作者，均按其各自许可证使用。

## 1. box4magisk —— 模块骨架与转发逻辑

- 项目：https://github.com/CHIZI-0618/box4magisk
- 作者：CHIZI-0618
- 许可证：GPL-3.0
- 本仓库使用部分：`module/customize.sh`、开机脚本 `box4_service.sh`、守护 `box4_watchdog.sh`、
  `/data/adb/box/scripts/` 下整套脚本（`box.service`、`box.tproxy`、`box.config`、`start.sh`、
  `box.inotify`、`net.inotify`）、iptables 规则模板、模块目录约定
- 修改说明：`customize.sh` 增加了 `box`（唯一入口）/ `sub.txt` 的安装与"首次安装不自启"保护；
  其余脚本未改动

## 2. mihomo —— 代理内核

- 项目：https://github.com/MetaCubeX/mihomo
- 作者：MetaCubeX 及 Clash / Mihomo 全体贡献者
- 许可证：GPL-3.0
- 本包内置二进制：`mihomo Meta v1.19.13 android arm64`（`go1.25.0`，`tags: with_gvisor`，构建时间 2025-08-27）
- GPL 合规：对应源码可从上述仓库 `v1.19.13` tag 获取；如需本包所用构建参数的完整源码副本，请开 Issue

## 3. MetaCubeXD —— Web 面板

- 项目：https://github.com/MetaCubeX/metacubexd
- 本包内置：其构建产物（`/data/adb/box/mihomo/ui/`），未修改

## 4. GeoIP / GeoSite 数据

- 项目：https://github.com/MetaCubeX/meta-rules-dat
- 本包内置：`GeoIP.dat`、`GeoSite.dat`、`geoip.metadb`，随上游模块包分发，未修改

## 5. 运行环境相关

- Magisk：https://github.com/topjohnwu/Magisk（GPL-3.0）
- KernelSU：https://github.com/tiann/KernelSU（GPL-3.0）
- APatch：https://github.com/bmax121/APatch（GPL-3.0）

## 本仓库新增的部分

| 文件 | 说明 |
| --- | --- |
| `config/config-template.yaml` | 订阅式 mihomo 配置（3 KB），只有 `__SUB_URL__` 占位符；含 TikTok 系域名走代理侧 DoH |
| `scripts/box` | 唯一入口：`on` / `off` / `sub` / `iface` / `webui` / `status`（不带参数=打印状态） |
| `scripts/webroot_index.html` | 7895 订阅设置页（busybox httpd），前端页面 |
| `scripts/webroot_cgi_api` | 7895 设置页后端（CGI，POST 明文提交订阅） |
| `module/box4_watchdog.sh` | 看门狗：按 `PROXY_PREROUTING` 判断，v6.4 增加策略路由自检 |
| `README.md` / `docs/使用说明.md` | 文档 |

以上新增部分同样按 GPL-3.0 发布。

> 上游基线脚本（`box.tproxy` / `box.service` / `tproxy.conf` 等）不在本仓库重复分发，
> 请从上游 [box4magisk](https://github.com/CHIZI-0618/box4magisk) main 分支获取；
> 本项目的改动只有 `tproxy.conf` 的四接口开关、`ap+` 热点接口名与 `DNS_HIJACK_ENABLE=2`。
