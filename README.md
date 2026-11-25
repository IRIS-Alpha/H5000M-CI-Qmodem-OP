<div align="center">
  <h1>H5000M-CI-Qmodem-OP</h1>
  <p>面向 H5000M、AP3000M 与 x86_64 的 ImmortalWrt 定制固件 · 默认集成 OpenClash</p>
</div>

[![CI](https://img.shields.io/github/actions/workflow/status/IRIS-Alpha/H5000M-CI-Qmodem-OP/WRT-CORE.yml?branch=main&style=for-the-badge&logo=github&label=build)](https://github.com/IRIS-Alpha/H5000M-CI-Qmodem-OP/actions)
[![Release](https://img.shields.io/github/v/release/IRIS-Alpha/H5000M-CI-Qmodem-OP?style=for-the-badge&color=0284c7)](https://github.com/IRIS-Alpha/H5000M-CI-Qmodem-OP/releases)
[![License: MIT](https://img.shields.io/badge/license-MIT-6366f1?style=for-the-badge)](LICENSE)

## 📄 许可证

> [!IMPORTANT]
> 本仓库的构建脚本与配置沿用上游 [MIT 许可证及版权声明](LICENSE)；
> 固件中的各组件适用各自的许可证与版权声明。使用或再分发前请自行确认。

## ⬇️ 下载固件

**[从 GitHub Releases 下载最新固件](https://github.com/IRIS-Alpha/H5000M-CI-Qmodem-OP/releases)** ·
[查看固件发布落地页](index.html)

## 🧭 关于上游

本项目 Fork 自 [LianXia233/H5000M-CI-Qmodem](https://github.com/LianXia233/H5000M-CI-Qmodem)，
基于 ImmortalWrt 为 H5000M、AP3000M 与 x86_64 构建固件，覆盖 QModem / QModem Next / Modem Pro 等模组方案。
上游负责设备适配、模组方案、在线升级与通用构建；本页只描述本仓库的差异。

| 上游主题 | 入口 |
| --- | --- |
| 设备支持、模组方案 | [上游 README](https://github.com/LianXia233/H5000M-CI-Qmodem#readme) |
| 在线升级与通用构建 | [上游 README](https://github.com/LianXia233/H5000M-CI-Qmodem#readme) |
| 完整出厂参数 | [`Config/OWRT-DEFAULT.txt`](Config/OWRT-DEFAULT.txt) |
| 各机型编译配置 | [`Config/`](Config/) |
| 变更历史与问题修复 | [`CHANGELOG.md`](CHANGELOG.md) |

> [!NOTE]
> 上游 README 中的 CI 工作流、构建调度与 Release 清理等长篇说明不在本页重复；
> 需要时请查阅上游仓库的 `.github/workflows/`。

## 🔧 本仓库改动

| 改动 | 说明 |
| --- | --- |
| 🛡️ 默认代理 | 默认使用 OpenClash，包选择见 [`Config/PRIVATE.txt`](Config/PRIVATE.txt) |
| 🌀 H5000M 风扇 | 使用 [`h5000m-pwmfan`](https://github.com/IRIS-Alpha/h5000m-pwmfan) 替换上游默认风扇插件 |
| 🧹 Release 保留 | 固件发布成功后，按编译配置、源码仓库所有者与分支分组，每组保留最近 5 个已发布的 Release；手动运行 `Auto-Clean` 时有独立清理选项，默认清理全部非草稿 Release |
| 🈶 简体中文界面 | Vantage 的「仪表盘」改为「概览」，QModem Next 的「调制解调器」改为「模组」 |

## 🏠 路由器出厂默认配置

| 项目 | 默认值 |
| --- | --- |
| 管理后台 | `http://192.168.10.1` |
| 管理账号 | `root` |
| 管理密码 | 留空（无密码） |
| Wi-Fi 名称 | `OWRT` |
| Wi-Fi 密码 | `12345678` |

> [!TIP]
> 刷机后先连接 Wi-Fi `OWRT` / `12345678`，再打开 `http://192.168.10.1`（账号 `root`，密码留空），
> 并按页面提示设置管理密码。完整出厂参数见 [`Config/OWRT-DEFAULT.txt`](Config/OWRT-DEFAULT.txt)。

## 📦 固件产物命名规则

Release 资产统一命名为：

```text
<配置名>-<架构>-<YY.MM.DD>-<镜像类型>.<扩展名>
```

- `<配置名>`：`H5000M-qmodem` / `H5000M-qmodem-next` / `H5000M-modem-pro` / `AP3000M-…` / `X86-qmodem` / `X86-qmodem-next`
- `<架构>`：`aarch64`（MTK）/ `x86-64`（X86）
- `<YY.MM.DD>`：构建当天日期（`Asia/Shanghai`）
- `<镜像类型>`：`sysupgrade` / `combined` / `combined-efi` / `vmdk` / `iso` 等

| 产物 | 实际文件名示例 |
| --- | --- |
| MTK 传统版 | `H5000M-qmodem-aarch64-26.11.17-sysupgrade.bin` |
| MTK QModem Next | `H5000M-qmodem-next-aarch64-26.11.17-sysupgrade.bin` |
| MTK Modem Pro | `H5000M-modem-pro-aarch64-26.11.17-sysupgrade.bin` |
| X86 UEFI | `X86-qmodem-next-x86-64-26.11.17-combined-efi.img.gz` |
| X86 BIOS | `X86-qmodem-next-x86-64-26.11.17-combined.img.gz` |
| X86 虚拟磁盘 | `X86-qmodem-next-x86-64-26.11.17-combined.vmdk` |

> [!IMPORTANT]
> **镜像类型后缀必须保留**：X86 单次构建会产出 EFI / BIOS 与 `img.gz` / `vmdk` / `iso` / `rootfs` / `kernel` 等多种格式，去掉类型后缀会互相覆盖。
> `.manifest` / `.config.txt` 已不再发布，仅作历史记录，故不列入上表。

> [!WARNING]
> **旧固件 OTA 过渡**：旧固件的 `firmware_pattern` 在构建期固化，仍是平台前缀式正则，无法匹配新命名。
> 刷过旧版的设备需手动下载对应 `*-sysupgrade.bin` 刷入一次（X86 用 `*-combined-efi.img.gz`），
> 或先在 LuCI 把 `firmware_pattern` 改为新正则；新出厂固件已内置新正则，不受影响。

## ❓ 常见问题

<details><summary>该刷哪个变体？</summary>

按设备与前端选择：QModem Next / 传统 LuCI / Modem Pro，机型适配细节见 [上游 README](https://github.com/LianXia233/H5000M-CI-Qmodem#readme)。

</details>

<details><summary>旧固件还能一键 OTA 吗？</summary>

见上文「固件产物命名规则」中的旧固件 OTA 过渡提示。

</details>

---

感谢 [LianXia233/H5000M-CI-Qmodem](https://github.com/LianXia233/H5000M-CI-Qmodem) 及所有上游组件维护者。
