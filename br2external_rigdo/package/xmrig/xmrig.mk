#############################################################
#
# xmrig
#
#############################################################

XMRIG_VERSION = 5.1.0
XMRIG_SITE = $(call github,xmrig,xmrig,v$(XMRIG_VERSION))

XMRIG_DEPENDENCIES = libuv

#XMRIG_CONF_OPTS += -DWITH_HTTPD=OFF
XMRIG_CONF_OPTS += -DWITH_HWLOC=OFF

define XMRIG_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/xmrig $(TARGET_DIR)/root/xmrig
endef

$(eval $(cmake-package))
