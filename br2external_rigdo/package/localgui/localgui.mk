#############################################################
#
# localgui
#
#############################################################

LOCALGUI_VERSION = master
LOCALGUI_SITE = $(call github,rigdo,webgen,$(LOCALGUI_VERSION))

LOCALGUI_DEPENDENCIES = libwt

#LOCALGUI_CONF_OPTS += -DWITH_HTTPD=OFF

define LOCALGUI_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/localgui $(TARGET_DIR)/root/localgui
	$(INSTALL) -D -m 0644 $(@D)/css/style.css $(TARGET_DIR)/home/http/css/style.css
	$(INSTALL) -D -m 0644 $(@D)/webgui_ru.xml $(TARGET_DIR)/home/http/webgui_ru.xml
	$(INSTALL) -D -m 0644 $(@D)/webgui_en.xml $(TARGET_DIR)/home/http/webgui_en.xml
endef

$(eval $(cmake-package))
