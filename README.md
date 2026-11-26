# box4 Subscription Edition · Android Transparent Proxy (mihomo + TPROXY / Magisk · KernelSU · APatch)

<h2>box4 订阅版 · 安卓全 App 透明代理（mihomo + TPROXY / Magisk · KernelSU · APatch）</h2>

> 关键词：Magisk 透明代理、KernelSU 模块、mihomo 订阅、TPROXY、Clash 订阅、安卓全局代理、旁路由（Bypass Router / Side Router）、热点共享代理、不占系统 VPN、DNS 防污染、局域网直连、box4magisk 订阅配置

> Keywords: Magisk transparent proxy, KernelSU module, mihomo subscription, Clash subscription, TPROXY, Android system-wide proxy, bypass router, side router, hotspot proxy sharing, no VpnService conflict, fake-ip DoH DNS, LAN direct connection

把 [box4magisk](https://github.com/CHIZI-0618/box4magisk)（mihomo 内核 + TPROXY）打包成一个"填一条订阅就能用"的 Magisk / KernelSU / APatch 模块。

## 它能做什么

- **全 App 透明代理**：走的是 iptables TPROXY 内核层劫持 TCP/UDP，不是 VpnService。所有 App 流量自动出网，包括 Telegram、WhatsApp、YouTube、Netflix、ChatGPT、Google Play、X（Twitter）、Instagram、TikTok 这些**不认系统代理**的 App
- **手机直接当旁路由**：热点（ap / wlan / ncm / usb）与局域网流量一起接管，连着手机热点的笔记本、平板、电视盒子、另一台手机，**不用逐台设代理**就能出网
- **不占系统 VPN 槽**：不需要 VpnService，能和公司 VPN、WireGuard、Tailscale 同时开，互不冲突
- **智能分流**：GEOSITE cn + GEOIP CN 国内直连；`192.168` / `10` / `172.16` / `100.64` 局域网直连（NAS、路由器、ZeroTier、Tailscale、树莓派都算）；其余走代理组
- **DNS 防污染**：fake-ip 模式 + DoH 分流，google / youtube / telegram / github / openai 各自指定 DoH，减少 DNS 泄漏
- **订阅式配置，只有 3 KB**：节点全部来自你自己的 `proxy-providers`，每 6 小时自动更新，健康检查 10 分钟一次；换机场只改一个 URL
- **热开关**：网页上点一下即开/关，关闭时内核进程直接退出、内存归零，不用重启手机
- **Web 面板**（MetaCubeXD）：`127.0.0.1:9090/ui` 选节点、看连接、看实时速率
- **一个节点都不带**：不含任何人的节点和订阅链接，只有占位符 `__SUB_URL__`，可以放心公开分发

## 适用场景

| 场景 | 用法 |
| --- | --- |
| 手机自己上境外服务 | 刷入模块 → 填订阅 → 全 App 自动走代理 |
| 出差 / 酒店 / 临时办公 | 手机开热点，笔记本连热点，流量自动经手机出网，笔记本上不用装任何客户端 |
| 家里已有旁路由但内存吃紧 | 让手机当二级出口，路由器那台只做分流，不背全部节点 |
| 设备多、逐台配置太烦 | 连同一热点的设备一次性接管，新设备接入即生效 |
| 需要同时保留公司 VPN | 不占 VpnService，两个可以并存 |
| 老机 / 低内存机型 | 平时关掉热开关，要用再点开，空闲内存立即回收 |

**不适合**：非 root 设备、32 位（armeabi-v7a）机型、只给 `vless://` 纯文本订阅的机场（本模块只吃 mihomo / clash 的 yaml）、需要桌面级 TUN 的场景。

## 和常见方案的区别

| 方案 | 需要 root | 占系统 VPN | 热点设备是否自动走代理 | 配置大小 |
| --- | --- | --- | --- | --- |
| Clash for Android / v2rayNG / Surfboard | 不需要 | **占**（同时只能开一个 VPN） | 只能给同网设备当 HTTP/SOCKS 代理，热点下每台设备还得手动设 | 订阅节点全量 |
| box4magisk 原版 | 需要 | 不占 | 支持 | 172 个内联节点，约 45 KB |
| **本模块** | 需要 | 不占 | **支持，接入即生效** | 3 KB，纯订阅 |

## 环境要求

| 项目 | 要求 |
| --- | --- |
| 架构 | **arm64-v8a**（内核是 arm64 二进制，armeabi-v7a 设备不适用） |
| 权限 | Magisk / KernelSU / APatch 已 root（KernelSU 需 `KSU_VER_CODE ≥ 10670`） |
| 系统 | Android 8.0+，内核支持 iptables mangle 表与 TPROXY（绝大多数高通/联发科机型可以） |
| 订阅 | **mihomo / clash 的 yaml 订阅**（机场后台一般叫"Clash 订阅"）；`vless://` 纯文本订阅不适用 |

## 安装

1. 从 [Releases](../../releases) 下载 `box4-共享版-v6.5-*.zip`
2. 在 Magisk / KernelSU / APatch 管理器里刷入，重启手机
3. 打开手机浏览器 `http://127.0.0.1:7895`

## 填订阅（网页里填，小白也能用）

设置页就在模块自带的服务里，**页面地址 `http://127.0.0.1:7895`**：

1. 打开页面
2. 把机场的 Clash / mihomo 订阅链接粘进输入框
3. 点「保存并应用」，等几秒，页面上的「节点数」变成非 0 就通了

页面同一张卡片里还有：

- **开启 / 彻底关闭 / 刷新** 三个按钮
- **四个接口独立开关**：移动数据、WiFi、热点、USB，默认**全开**，点一下就单独断开或恢复（会自动重启转发规则）
- 面板入口 `9090/ui`

命令行等价操作（也能用）：

```sh
sh /data/adb/box/box sub "https://你的订阅链接"   # 直接给链接
sh /data/adb/box/box sub                         # 按 sub.txt 里那一行
```

脚本会备份 config → 用 awk 字面替换写入订阅 → 清缓存 → 重启内核 → 重建规则，并打印节点数。链接里带 `& | ?` 都不会写坏。

> 首次安装会故意**不自启**（写入 `/data/adb/box/manual` 标记），避免还没填订阅就把网络劫持到空代理。在网页里点「保存并应用」会自动解除该标记。

## 日常使用

- 设置页：`http://127.0.0.1:7895`（同一局域网 `http://手机IP:7895`）
- 面板：手机浏览器 `http://127.0.0.1:9090/ui`；同一局域网电脑 `http://手机IP:9090/ui`
- 代理组：
  - `🚀 自动` = `url-test`，按延迟自动挑节点，节点挂了自动换
  - `🎯 选择` = 手动指定，默认跟随自动组，点具体节点即可固定
- 订阅：`interval: 21600`（6 小时）自动更新，`health-check` 每 10 分钟探活
- 端口：mixed `7890` / redir `7891` / tproxy `1536` / 面板 `9090`

### 一键开关（在网页里点）

开关全在设置页 `http://127.0.0.1:7895` 的两个按钮上：

- **开启**：拉起内核 → 重建规则 → 起看门狗，几秒完成，无需重启手机
- **彻底关闭**：撤掉 mangle 转发规则 → 杀 mihomo（内存立刻释放）→ 停看门狗 → 写 `manual` 标记，开机不再自启

要看当前状态，开 `http://127.0.0.1:7895`，或直接运行 `sh /data/adb/box/box`。命令行也保留 `box` 这一个入口：

```sh
sh /data/adb/box/box on        # 全部启动
sh /data/adb/box/box off       # 全部关闭
sh /data/adb/box/box sub       # 按 sub.txt 填订阅
sh /data/adb/box/box status    # 看状态
sh /data/adb/box/box iface hotspot on|off   # 单个接口开关（mobile/wifi/hotspot/usb）
sh /data/adb/box/box webui on|off           # 设置页起停
```

> 想把热点/局域网交给别的 VPN（例如 Clash Plus、ZeroTier），直接用 VPN Hotspot App 桥接即可，本模块不提供暂停/让位档位。

### 当旁路由用（Bypass Router / Side Router）

模块默认 `allow-lan: true` + `bind-address: '*'`，所以手机本身就是一台现成的旁路由：别的设备连上手机热点、或跟手机在同一局域网，就能借手机的代理出网，不用在那台设备上再折腾节点。

- **电脑 / 平板 / 另一台手机**：代理地址填 `http://手机IP:7890`（mixed 端口），DNS 可选 `手机IP:1053`
- **另一台 OpenWrt / 软路由**：把它自己的 mihomo / clash 上游指到 `手机IP:7890`，或者直接转发整段流量过来
- **只有浏览器要用**：SwitchyOmega 之类的插件填同一个 `手机IP:7890` 即可
- 手机侧注意：别让系统把 box4 后台杀掉（电池优化里给「不受限制」），必要时代理规则里把 `192.168.0.0/16` 这类网段保持直连，避免绕回自己

> 关掉热开关后这些共享入口会一起失效——因为内核进程已经退出，不是防火墙拦住了。

## FAQ

- **刷完上不了网**：订阅还没填，模块此时故意不自启。打开 `http://127.0.0.1:7895` 填链接即可。
- **个别网站打不开、别的正常**：该节点不支持，面板换一个（例如 Telegram 网页版对部分 HK 节点不友好）。
- **想彻底卸载**：管理器里卸载模块即可，`uninstall.sh` 会清掉开机脚本、进程、`PROXY_*` 链与 `ip rule`（`fwmark 0x14 → table 2025`）。残留目录 `/data/adb/box` 手动 `rm -rf` 一次。
- **内存占用**：空载约 50 MB，全量 285 节点约 150 MB；关掉开关后归零。
- **重启后 WiFi 图标显示「无网络」，但热点/移动数据正常**：这是策略路由表里的 `local default dev lo` 被系统清掉，导致被标记的流量回落直连、探活 DNS 失败。看门狗每 15 秒自检并补回该路由与 `fwmark` 规则，实测删掉后 20 秒内自愈，不用手动处理。

## 致谢与来源

本模块不是从零写的，绝大部分运行逻辑来自上游项目，请先给原作者点个 star：

- **[CHIZI-0618/box4magisk](https://github.com/CHIZI-0618/box4magisk)**（按其仓库 LICENSE，GPL-3.0）——模块骨架、`customize.sh`、`box.service` / `box.tproxy` / `start.sh` 等整套脚本、开机与守护逻辑、iptables 规则模板均来自该项目，作者 **CHIZI-0618**。
- **[MetaCubeX/mihomo](https://github.com/MetaCubeX/mihomo)**（GPL-3.0）——本包内置 `mihomo Meta v1.19.13 android arm64`（go1.25.0，tags: with_gvisor），作者 **MetaCubeX** 及 Clash/Mihomo 全体贡献者。
- **[MetaCubeX/metacubexd](https://github.com/MetaCubeX/metacubexd)**——Web 面板 MetaCubeXD，本包内置其构建产物。
- **[MetaCubeX/meta-rules-dat](https://github.com/MetaCubeX/meta-rules-dat)**——GeoIP / GeoSite 数据文件随上游包分发。

我在上游基础上的改动只有这些：

1. `mihomo/config.yaml` 从 172 个内联节点改成订阅式（3 KB，`proxy-providers` + 两个组），并保留 LAN 直连规则
2. `box/scripts/` 直接采用上游 main 的执行基线（`box.tproxy` v26.04.07 + `tproxy.conf` + `box.service`），不自己维护规则代码
3. `tproxy.conf` 适配本机：`PROXY_MOBILE` / `PROXY_WIFI` / `PROXY_HOTSPOT` / `PROXY_USB` 四项默认全开，热点接口 `ap+`，`DNS_HIJACK_ENABLE=2`
4. 新增 `/data/adb/box/box`（唯一入口：`on` / `off` / `sub` / `iface` / `webui` / `status`；不带参数=打印状态），模块卡片保持干净，不出现「执行」按钮
5. 新增 7895 订阅设置页（`busybox httpd` + CGI，POST 明文提交链接），四个接口开关也在页面里
6. 订阅只填 `/data/adb/box/sub.txt` 一行，`box sub` 用 awk 字面替换写入（`& | ?` 原样保留）
7. 看门狗按 `PROXY_PREROUTING` 判断、只保规则不拉内核，并额外做策略路由自检（补回 `table 2025` 的 `local dev lo` 路由与 `fwmark` 规则）
8. 打包成"零节点"共享版，并补了这份说明

如果你的机场节点列表、订阅 token 出现在任何提交里，请当作泄露处理——本仓库已刻意剔除。

## 实现要点

分五块：

- **流量接管**：iptables TPROXY 在内核层劫持 TCP/UDP，移动数据 / WiFi / 热点 / USB 四类接口统一生效，不占系统 VPN 槽，可与公司 VPN、WireGuard、Tailscale 并存
- **配置与界面**：`127.0.0.1:7895` 网页里直接填订阅、开关、换线路，全程不碰文件；关闭时内核进程退出、内存归零，不需要重启手机
- **DNS 真正落地**：全量 DNS 劫持到 mihomo 的 1053 端口，让 fake-ip 分流生效；TikTok 系域名单独走代理侧 DoH 解析，海外 App 不再出现"显示无网络"
- **链路自愈**：看门狗按规则锚点自检，策略路由表丢失、规则被系统清理、内核意外退出都会自动补回，实测 20 秒内恢复
- **数据与运维**：geo 数据走 CDN 自动更新（7 天周期），内核日志自动裁到最近 3 份，设置页按真实进程判活——长期挂着不膨胀、不堆垃圾

## License

GPL-3.0（与上游 box4magisk、mihomo 保持一致），详见 [LICENSE](LICENSE)。

## 免责声明

本项目仅提供网络流量转发工具，不含任何节点与服务。使用需遵守当地法律法规及你所购买服务的条款。作者不对设备变砖、数据丢失、账号风控等后果负责。
