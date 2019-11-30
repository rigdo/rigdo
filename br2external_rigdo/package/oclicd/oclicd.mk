#############################################################
#
# ocl-icd
#
#############################################################

OCLICD_VERSION = 2.2.12
OCLICD_SITE = $(call github,OCL-dev,ocl-icd,v$(OCLICD_VERSION))
OCLICD_INSTALL_STAGING = YES
OCLICD_AUTORECONF = YES

OCLICD_DEPENDENCIES += mesa3d-headers                                      
OCLICD_PROVIDES += libopencl                                               


$(eval $(autotools-package))
