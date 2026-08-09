# 更新日志

## [2026-08-09]

### 修复
- **WiFi 加密**：修复 AP3000M 开源 mt76 驱动下 WiFi 密码不生效的问题。`mac80211.uc` 默认生成 `encryption='none'`，Settings.sh 仅修改了 `ssid` 和 `key` 而未设置加密方式，导致密码被忽略。现已追加 `encryption='psk2'` 设置。
- **默认时区**：修复固件默认时区为 UTC 的问题。`config_generate` 默认写入 `timezone='GMT0'` / `zonename='UTC'`，现已改为 `CST-8` / `Asia/Shanghai`（北京时间）。
- **AP3000M 风扇插件缺失**：修复 AP3000M 编译时 `luci-app-airpi-fancontrol` 和 `kmod-airpi-gpio-fan` 未被编入的问题。`Packages.sh` 中仅有 H5000M 风扇插件，现已追加 AP3000M 对应的 `luci-app-airpi3000m-fancontrol` 仓库克隆语句。

### 变更文件
- `Scripts/Settings.sh` — WiFi 加密修复 + 默认时区修复
- `Scripts/Packages.sh` — 新增 `luci-app-airpi-fancontrol` 仓库克隆
