<div align="center">
  <h1>H5000M-CI-Qmodem-OP</h1>
  <p>面向 H5000M、AP3000M 与 x86_64 的 ImmortalWrt 定制固件 · 默认集成 OpenClash</p>
</div>

[![CI](https://img.shields.io/github/actions/workflow/status/IRIS-Alpha/H5000M-CI-Qmodem-OP/WRT-BUILD.yml?branch=main&style=for-the-badge&logo=github&label=build)](https://github.com/IRIS-Alpha/H5000M-CI-Qmodem-OP/actions/workflows/WRT-BUILD.yml)
[![Release](https://img.shields.io/github/v/release/IRIS-Alpha/H5000M-CI-Qmodem-OP?style=for-the-badge&color=0284c7)](https://github.com/IRIS-Alpha/H5000M-CI-Qmodem-OP/releases)
[![License: MIT](https://img.shields.io/badge/license-MIT-6366f1?style=for-the-badge)](LICENSE)

## 📄 许可证

> [!IMPORTANT]
> 本仓库的构建脚本与配置沿用上游 [MIT 许可证及版权声明](LICENSE)；
> 固件中的各组件适用各自的许可证与版权声明。使用或再分发前请自行确认。

## ⬇️ 下载固件

**[从 GitHub Releases 下载本仓库固件](https://github.com/IRIS-Alpha/H5000M-CI-Qmodem-OP/releases)**

## 🧭 关于上游

本项目 Fork 自 LianXia233/H5000M-CI-Qmodem。设备支持、模组方案、在线升级与通用构建说明见 [上游 README](https://github.com/LianXia233/H5000M-CI-Qmodem#readme)。

## 🔧 本仓库改动

| 改动 | 说明 |
| --- | --- |
| 🛡️ 默认代理 | 默认使用 OpenClash，包选择见 [`Config/PRIVATE.txt`](Config/PRIVATE.txt) |
| 🌀 H5000M 风扇 | 使用 [`h5000m-pwmfan`](https://github.com/IRIS-Alpha/h5000m-pwmfan) 替换上游默认风扇插件 |
| 🧹 Release 保留 | 固件发布成功后，按编译配置、源码仓库所有者与分支分组，每组保留最近 5 个已发布的 Release；手动运行 `Auto-Clean` 时有独立清理选项，默认清理全部非草稿 Release |
| 🈶 简体中文界面 | Vantage 的「仪表盘」改为「概览」，QModem Next 的「调制解调器」改为「模组」 |

各机型编译配置见 [`Config/`](Config/)，历史变更见 [`CHANGELOG.md`](CHANGELOG.md)。

## 🏠 路由器出厂默认配置

| 项目 | 默认值 |
| --- | --- |
| 管理后台 | `http://192.168.10.1` |
| 管理账号 | `root` |
| 管理密码 | 留空（无密码） |
| Wi-Fi 名称 | `OWRT` |
| Wi-Fi 密码 | `12345678` |

> [!TIP]
> 刷机后接入设备的 LAN 口，或在设备提供 Wi-Fi 时连接 `OWRT`。打开 `http://192.168.10.1`，
> 用 `root` 和空密码登录，再按页面提示设置管理密码。完整出厂参数见 [`Config/OWRT-DEFAULT.txt`](Config/OWRT-DEFAULT.txt)。

## 📦 固件产物命名规则

发布的固件镜像采用以下命名格式。

```text
<配置名>-<架构>-<YY.MM.DD>-<镜像类型>.<扩展名>
```

- `<配置名>`：`H5000M-qmodem` / `H5000M-qmodem-next` / `H5000M-modem-pro` / `AP3000M-…` / `X86-qmodem` / `X86-qmodem-next`
- `<架构>`：`aarch64`（MTK）/ `x86-64`（X86）
- `<YY.MM.DD>`：构建当天日期（`Asia/Shanghai`）
- `<镜像类型>` 为 `sysupgrade`、`factory`、`combined`、`combined-efi`、`image` 或 `image-efi`。
- `<扩展名>` 为 `bin`、`img.gz`、`vmdk` 或 `iso`，具体取决于镜像类型。

| 产物 | 实际文件名示例 |
| --- | --- |
| MTK 传统版 | `H5000M-qmodem-aarch64-26.11.17-sysupgrade.bin` |
| MTK QModem Next | `H5000M-qmodem-next-aarch64-26.11.17-sysupgrade.bin` |
| MTK Modem Pro | `H5000M-modem-pro-aarch64-26.11.17-sysupgrade.bin` |
| X86 UEFI | `X86-qmodem-next-x86-64-26.11.17-combined-efi.img.gz` |
| X86 BIOS | `X86-qmodem-next-x86-64-26.11.17-combined.img.gz` |
| X86 虚拟磁盘 | `X86-qmodem-next-x86-64-26.11.17-combined.vmdk` |

> [!IMPORTANT]
> **按设备、模组方案和启动方式选择镜像。** x86 的磁盘镜像分为 UEFI（`combined-efi.img.gz`）和 Legacy BIOS（`combined.img.gz`）。

> [!WARNING]
> **在线升级**默认从上游仓库查找固件，x86 预设默认匹配 UEFI 镜像。使用本仓库的固件时，请确认 LuCI 在线升级的仓库、标签规则和镜像匹配规则指向对应发布。旧版的 `firmware_pattern` 可能无法匹配现有文件名。此时可更新匹配规则，或从本仓库 Releases 下载与当前设备、模组方案及启动方式相符的镜像手动升级。预设见 [`Scripts/OnlineUpgradePreset.sh`](Scripts/OnlineUpgradePreset.sh)。

---

感谢 [LianXia233/H5000M-CI-Qmodem](https://github.com/LianXia233/H5000M-CI-Qmodem) 及所有上游组件维护者。
