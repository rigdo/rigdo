################################################################################
#
# libamdocl64
#
################################################################################

#LIBAMDOCL64_VERSION = 1.0
#EX_NVIDIA_DRIVER_SUFFIX = $(if $(BR2_x86_64),_64)
#EX_NVIDIA_DRIVER_SITE = http://download.nvidia.com/XFree86/Linux-x86$(EX_NVIDIA_DRIVER_SUFFIX)/$(EX_NVIDIA_DRIVER_VERSION)
#EX_NVIDIA_DRIVER_SOURCE = NVIDIA-Linux-x86$(EX_NVIDIA_DRIVER_SUFFIX)-$(EX_NVIDIA_DRIVER_VERSION).run
#EX_NVIDIA_DRIVER_LICENSE = NVIDIA Software License
#EX_NVIDIA_DRIVER_LICENSE_FILES = LICENSE
#EX_NVIDIA_DRIVER_REDISTRIBUTE = NO
#EX_NVIDIA_DRIVER_INSTALL_STAGING = YES


#EX_NVIDIA_DRIVER_LIBS += \
	libOpenCL.so.1.0.0 \
	libnvidia-opencl.so.$(EX_NVIDIA_DRIVER_VERSION)
LIBAMDOCL64_DEPENDENCIES += libhsart

$(eval $(generic-package))
