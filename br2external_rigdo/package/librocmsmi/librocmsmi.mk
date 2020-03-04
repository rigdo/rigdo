################################################################################
#
# librocmsmi
#
################################################################################

LIBROCMSMI_VERSION = 3.1.0
LIBROCMSMI_SITE = $(call github,RadeonOpenCompute,rocm_smi_lib,roc-$(LIBROCMSMI_VERSION))
LIBROCMSMI_INSTALL_STAGING = YES
#LIBROCMSMI_DEPENDENCIES = numactl
#LIBROCMSMI_LICENSE = LGPL-2.1+

$(eval $(cmake-package))
