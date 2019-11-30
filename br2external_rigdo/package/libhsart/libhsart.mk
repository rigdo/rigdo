################################################################################
#
# libhsart
#
################################################################################

LIBHSART_VERSION = 2.9.0
LIBHSART_SITE = $(call github,RadeonOpenCompute,ROCR-Runtime,roc-$(LIBHSAKMT_VERSION))
LIBHSART_INSTALL_STAGING = YES
LIBHSART_DEPENDENCIES = elfutils libhsakmt
LIBHSART_LICENSE = LGPL-2.1+
LIBHSART_SUBDIR=src

$(eval $(cmake-package))
