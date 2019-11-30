#############################################################
#
# xmrig-proxy
#
#############################################################

XMRIG_PROXY_VERSION = 3.2.1
XMRIG_PROXY_SITE = $(call github,xmrig,xmrig-proxy,v$(XMRIG_PROXY_VERSION))

XMRIG_PROXY_DEPENDENCIES = libuv

define XMRIG_PROXY_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/xmrig-proxy $(TARGET_DIR)/root/xmrig-proxy
endef

$(eval $(cmake-package))
