################################################################################
#
# libhsakmt
#
################################################################################

LIBHSAKMT_VERSION = 2.9.0
LIBHSAKMT_SITE = $(call github,RadeonOpenCompute,ROCT-Thunk-Interface,roc-$(LIBHSAKMT_VERSION))
LIBHSAKMT_INSTALL_STAGING = YES
LIBHSAKMT_DEPENDENCIES = numactl
LIBHSAKMT_LICENSE = LGPL-2.1+

$(eval $(cmake-package))
