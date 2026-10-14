
#!/usr/bin/env bash
set -Eeuo pipefail

echo "========== Cudy TR3000 DIY 开始 =========="

# 1. 替换 Argon 主题
rm -rf feeds/luci/themes/luci-theme-argon
rm -rf package/luci-theme-argon
rm -rf package/luci-app-argon-config

git clone --depth 1 \
  https://github.com/jerrykuku/luci-theme-argon.git \
  package/luci-theme-argon

git clone --depth 1 \
  https://github.com/jerrykuku/luci-app-argon-config.git \
  package/luci-app-argon-config


# 2. 更新 Go 语言包到 1.27.x
rm -rf feeds/packages/lang/golang

git clone --depth 1 --branch 27.x \
  https://github.com/sbwml/packages_lang_golang \
  feeds/packages/lang/golang

echo "===== Go 编译工具链已切换到 27.x 分支 ====="

# 3. 替换 Passwall 相关依赖包
rm -rf feeds/packages/net/{xray-core,v2ray-geodata,sing-box,chinadns-ng,dns2socks,hysteria,ipt2socks,microsocks,naiveproxy,shadowsocks-libev,shadowsocks-rust,shadowsocksr-libev,simple-obfs,tcping,trojan-plus,tuic-client,v2ray-plugin,xray-plugin,geoview,shadow-tls}

rm -rf package/passwall-packages
git clone --depth 1 \
  https://github.com/Openwrt-Passwall/openwrt-passwall-packages \
  package/passwall-packages

# 4. 安装 Passwall2
rm -rf feeds/luci/applications/luci-app-passwall
rm -rf package/passwall2-luci

git clone --depth 1 \
  https://github.com/Openwrt-Passwall/openwrt-passwall2 \
  package/passwall2-luci

# 5. Tailscale 相关修改
if [ -f feeds/packages/net/tailscale/Makefile ]; then
  sed -i \
    '/\/etc\/init\.d\/tailscale/d;/\/etc\/config\/tailscale/d;' \
    feeds/packages/net/tailscale/Makefile
fi

rm -rf package/luci-app-tailscale
git clone --depth 1 \
  https://github.com/asvow/luci-app-tailscale \
  package/luci-app-tailscale

# 6. 设置固件文件名前缀
sed -i \
  's|IMG_PREFIX:=|IMG_PREFIX:=$(shell TZ="Asia/Shanghai" date +"%Y%m%d")-24.10-6.6-|' \
  include/image.mk

echo "========== Cudy TR3000 DIY 完成 =========="
