# H5000M-CI-Qmodem-OP

面向 H5000M、AP3000M 和 x86_64 的 ImmortalWrt 固件构建项目，是 `LianXia233/H5000M-CI-Qmodem` 的 Fork，默认集成 OpenClash。

**[下载本仓库固件（GitHub Releases）](https://github.com/IRIS-Alpha/H5000M-CI-Qmodem-OP/releases)**

## 许可证

本仓库的构建脚本与配置沿用上游的 [MIT 许可证及版权声明](LICENSE)。固件中的各组件适用各自的许可证与版权声明。

## 上游文档

设备支持、模组方案、在线升级和通用构建说明见 [上游 README](https://github.com/LianXia233/H5000M-CI-Qmodem#readme)。

## 路由器出厂默认配置

| 项目 | 默认值 |
| --- | --- |
| 管理后台 | `http://192.168.10.1` |
| 管理账号 | `root` |
| 管理密码 | 留空（无密码） |
| Wi-Fi 名称 | `OWRT` |
| Wi-Fi 密码 | `12345678` |

首次登录时按页面提示设置管理密码。完整出厂参数见 [`Config/OWRT-DEFAULT.txt`](Config/OWRT-DEFAULT.txt)。

## 本仓库改动

- **代理**：默认使用 OpenClash。包选择见 [`Config/PRIVATE.txt`](Config/PRIVATE.txt)。
- **H5000M 风扇**：使用 [`h5000m-pwmfan`](https://github.com/IRIS-Alpha/h5000m-pwmfan) 替换上游默认风扇插件。
- **发行版保留**：固件发布成功后，按编译配置、源码仓库所有者和分支分组，每组保留最近 5 个已发布的 Release。手动运行 `Auto-Clean` 时有独立的清理选项，默认会清理全部非草稿 Release。
- **简体中文界面**：Vantage 的“仪表盘”改为“概览”，QModem Next 的“调制解调器”改为“模组”。
