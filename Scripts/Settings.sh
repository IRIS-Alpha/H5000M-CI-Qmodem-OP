#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2026 VIKINGYFY

#移除luci-app-attendedsysupgrade
sed -i "/attendedsysupgrade/d" $(find ./feeds/luci/collections/ -type f -name "Makefile")
#修改默认主题
sed -i "s/luci-theme-bootstrap/luci-theme-$WRT_THEME/g" $(find ./feeds/luci/collections/ -type f -name "Makefile")
#修改immortalwrt.lan关联IP
sed -i "s/192\.168\.[0-9]*\.[0-9]*/$WRT_IP/g" $(find ./feeds/luci/modules/luci-mod-system/ -type f -name "flash.js")
#添加编译日期标识
sed -i "s/(\(luciversion || ''\))/(\1) + (' \/ $WRT_MARK-$WRT_DATE')/g" $(find ./feeds/luci/modules/luci-mod-status/ -type f -name "10_system.js")

WIFI_SH=$(find ./target/linux/mediatek/filogic/base-files/etc/uci-defaults/ -type f -name "*set-wireless.sh" 2>/dev/null)
WIFI_UC="./package/network/config/wifi-scripts/files/lib/wifi/mac80211.uc"
MTWIFI_SH="./package/mtk/applications/mtwifi-cfg/files/mtwifi.sh"

# 加密策略默认 psk-mixed（WPA/WPA2 混合，兼容新老终端）；
# MTK 闭源驱动栈（mtwifi）的 UCI 加密值需追加 +ccmp 后缀
WIFI_ENCRYPTION_UCI="${WIFI_ENCRYPTION:-psk-mixed}"
[ -f "$MTWIFI_SH" ] && WIFI_ENCRYPTION_UCI="${WIFI_ENCRYPTION_UCI}+ccmp"

if [ -f "$MTWIFI_SH" ]; then
	# 修改 MTK 闭源 Wi-Fi 驱动栈的默认名称和密码
	sed -i "s/ImmortalWrt-[[:alnum:].-]*/$WRT_SSID/g; s/encryption=none/encryption=$WIFI_ENCRYPTION_UCI/g" "$MTWIFI_SH"
	# 先移除可能存在的默认 key 行，再在 encryption 行后追加配置密钥（保证唯一且生效）
	sed -i "/set wireless.default_\${dev}.key=/d" "$MTWIFI_SH"
	sed -i "/set wireless.default_\${dev}.encryption=/a\\					set wireless.default_\${dev}.key='$WRT_WORD'" "$MTWIFI_SH"
elif [ -f "$WIFI_SH" ]; then
	#修改WIFI名称
	sed -i "s/BASE_SSID='.*'/BASE_SSID='$WRT_SSID'/g" $WIFI_SH
	#修改WIFI密码
	sed -i "s/BASE_WORD='.*'/BASE_WORD='$WRT_WORD'/g" $WIFI_SH
elif [ -f "$WIFI_UC" ]; then
	#修改WIFI名称
	sed -i "s/ssid='.*'/ssid='$WRT_SSID'/g" $WIFI_UC
	#修改WIFI加密方式
	sed -i "s/encryption='none'/encryption='$WIFI_ENCRYPTION_UCI'/g" $WIFI_UC
	#修改WIFI密码
	sed -i "s/key='.*'/key='$WRT_WORD'/g" $WIFI_UC
fi

# ===== 出厂无线默认参数（国家 / 频宽 / 加密）=====
# 由 Config/OWRT-DEFAULT.txt 驱动，生成首次启动脚本强制覆盖各驱动栈默认值，
# 保证 2.4G / 5G 频宽、国家码与加密策略出参一致。
WIFI_2G_HTMODE="HT${WIFI_2G_WIDTH:-40}"
WIFI_5G_HTMODE="HE${WIFI_5G_WIDTH:-160}"
if [[ "${WRT_CONFIG:-}" == *AP3000M* ]] && [ "${WIFI_5G_WIDTH:-160}" -gt 80 ]; then
	echo "AP3000M: 5G 频宽由 ${WIFI_5G_WIDTH}MHz 自动降级为 80MHz（MT7981 硬件上限）"
	WIFI_5G_HTMODE="HE80"
fi

WIFI_DEFAULTS_DIR="./files/etc/uci-defaults"
mkdir -p "$WIFI_DEFAULTS_DIR"
cat > "$WIFI_DEFAULTS_DIR/10-wifi-defaults" <<EOF
#!/bin/sh
# SPDX-License-Identifier: MIT
# 出厂默认无线参数：构建时由 Scripts/Settings.sh 依据 Config/OWRT-DEFAULT.txt 生成
WIFI_SSID='${WIFI_SSID:-OWRT}'
WIFI_KEY='${WIFI_WORD:-12345678}'
WIFI_ENCRYPTION='$WIFI_ENCRYPTION_UCI'
WIFI_2G_WIDTH='$WIFI_2G_HTMODE'
WIFI_5G_WIDTH='$WIFI_5G_HTMODE'
WIFI_COUNTRY='${WIFI_COUNTRY:-CN}'

[ -f /etc/config/wireless ] || exit 0

for radio in radio0 radio1; do
	case "\$(uci get wireless.\$radio.band 2>/dev/null)" in
		2g) uci -q set wireless.\$radio.htmode="\$WIFI_2G_WIDTH" ;;
		5g) uci -q set wireless.\$radio.htmode="\$WIFI_5G_WIDTH" ;;
	esac
	uci -q set wireless.\$radio.country="\$WIFI_COUNTRY"
done
for def in default_radio0 default_radio1; do
	uci -q set wireless.\$def.ssid="\$WIFI_SSID"
	uci -q set wireless.\$def.encryption="\$WIFI_ENCRYPTION"
	uci -q set wireless.\$def.key="\$WIFI_KEY"
done
uci -q commit wireless 2>/dev/null
exit 0
EOF
chmod +x "$WIFI_DEFAULTS_DIR/10-wifi-defaults"
echo "wifi defaults injected: 2G=${WIFI_2G_HTMODE} 5G=${WIFI_5G_HTMODE} country=${WIFI_COUNTRY:-CN} encryption=${WIFI_ENCRYPTION_UCI}"

CFG_FILE="./package/base-files/files/bin/config_generate"
#修改默认IP地址
sed -i "s/192\.168\.[0-9]*\.[0-9]*/$WRT_IP/g" $CFG_FILE
#修改默认主机名
sed -i "s/hostname='.*'/hostname='$WRT_NAME'/g" $CFG_FILE
#修改默认时区（由 Config/OWRT-DEFAULT.txt 的 WRT_TIMEZONE / WRT_ZONENAME 驱动）
sed -i "s/timezone='GMT0'/timezone='${WRT_TIMEZONE:-CST-8}'/g" $CFG_FILE
sed -i "s/zonename='UTC'/zonename='${WRT_ZONENAME:-Asia\/Shanghai}'/g" $CFG_FILE

#配置文件修改
echo "CONFIG_PACKAGE_luci=y" >> ./.config
echo "CONFIG_LUCI_LANG_zh_Hans=y" >> ./.config
echo "CONFIG_PACKAGE_luci-theme-$WRT_THEME=y" >> ./.config
echo "CONFIG_PACKAGE_luci-app-$WRT_THEME-config=y" >> ./.config

#引入私有扩展配置
if [ -f "$GITHUB_WORKSPACE/Config/PRIVATE.txt" ]; then
	echo "Applying private configurations from PRIVATE.txt..."
	cat $GITHUB_WORKSPACE/Config/PRIVATE.txt >> ./.config
fi

#手动调整的插件
if [ -n "$WRT_PACKAGE" ]; then
	echo -e "$WRT_PACKAGE" >> ./.config
fi
