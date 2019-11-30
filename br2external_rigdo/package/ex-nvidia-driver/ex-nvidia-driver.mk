################################################################################
#
# ex-nvidia-driver
#
################################################################################

EX_NVIDIA_DRIVER_VERSION = 440.31
EX_NVIDIA_DRIVER_SUFFIX = $(if $(BR2_x86_64),_64)
EX_NVIDIA_DRIVER_SITE = http://download.nvidia.com/XFree86/Linux-x86$(EX_NVIDIA_DRIVER_SUFFIX)/$(EX_NVIDIA_DRIVER_VERSION)
EX_NVIDIA_DRIVER_SOURCE = NVIDIA-Linux-x86$(EX_NVIDIA_DRIVER_SUFFIX)-$(EX_NVIDIA_DRIVER_VERSION).run
EX_NVIDIA_DRIVER_LICENSE = NVIDIA Software License
EX_NVIDIA_DRIVER_LICENSE_FILES = LICENSE
EX_NVIDIA_DRIVER_REDISTRIBUTE = NO
EX_NVIDIA_DRIVER_INSTALL_STAGING = YES


ifeq ($(BR2_PACKAGE_EX_NVIDIA_DRIVER_CUDA),y)
EX_NVIDIA_DRIVER_LIBS += \
	libcuda.so.$(EX_NVIDIA_DRIVER_VERSION) \
	libnvidia-compiler.so.$(EX_NVIDIA_DRIVER_VERSION) \
	libnvcuvid.so.$(EX_NVIDIA_DRIVER_VERSION) \
	libnvidia-fatbinaryloader.so.$(EX_NVIDIA_DRIVER_VERSION) \
	libnvidia-ptxjitcompiler.so.$(EX_NVIDIA_DRIVER_VERSION) \
	libnvidia-encode.so.$(EX_NVIDIA_DRIVER_VERSION) \
	libnvidia-ml.so.$(EX_NVIDIA_DRIVER_VERSION)
ifeq ($(BR2_PACKAGE_EX_NVIDIA_DRIVER_CUDA_PROGS),y)
EX_NVIDIA_DRIVER_PROGS = nvidia-cuda-mps-control nvidia-cuda-mps-server
endif
endif

ifeq ($(BR2_PACKAGE_EX_NVIDIA_DRIVER_OPENCL),y)
EX_NVIDIA_DRIVER_LIBS += \
	libOpenCL.so.1.0.0 \
	libnvidia-opencl.so.$(EX_NVIDIA_DRIVER_VERSION)
EX_NVIDIA_DRIVER_DEPENDENCIES += mesa3d-headers
EX_NVIDIA_DRIVER_PROVIDES += libopencl
endif

# Build and install the kernel modules if needed
ifeq ($(BR2_PACKAGE_EX_NVIDIA_DRIVER_MODULE),y)

EX_NVIDIA_DRIVER_MODULES = nvidia nvidia-modeset nvidia-drm
ifeq ($(BR2_x86_64),y)
EX_NVIDIA_DRIVER_MODULES += nvidia-uvm
endif

# They can't do everything like everyone. They need those variables,
# because they don't recognise the usual variables set by the kernel
# build system. We also need to tell them what modules to build.
EX_NVIDIA_DRIVER_MODULE_MAKE_OPTS = \
	NV_KERNEL_SOURCES="$(LINUX_DIR)" \
	NV_KERNEL_OUTPUT="$(LINUX_DIR)" \
	NV_KERNEL_MODULES="$(EX_NVIDIA_DRIVER_MODULES)"

EX_NVIDIA_DRIVER_MODULE_SUBDIRS = kernel

$(eval $(kernel-module))

endif # BR2_PACKAGE_EX_NVIDIA_DRIVER_MODULE == y

# The downloaded archive is in fact an auto-extract script. So, it can run
# virtually everywhere, and it is fine enough to provide useful options.
# Except it can't extract into an existing (even empty) directory.
define EX_NVIDIA_DRIVER_EXTRACT_CMDS
	$(SHELL) $(EX_NVIDIA_DRIVER_DL_DIR)/$(EX_NVIDIA_DRIVER_SOURCE) --extract-only --target \
		$(@D)/tmp-extract
	chmod u+w -R $(@D)
	mv $(@D)/tmp-extract/* $(@D)/tmp-extract/.manifest $(@D)
	rm -rf $(@D)/tmp-extract
endef

# Helper to install libraries
# $1: destination directory (target or staging)
#
# For all libraries, we install them and create a symlink using
# their SONAME, so we can link to them at runtime; we also create
# the no-version symlink, so we can link to them at build time.
define EX_NVIDIA_DRIVER_INSTALL_LIBS
	$(foreach lib,$(EX_NVIDIA_DRIVER_LIBS),\
		$(INSTALL) -D -m 0644 $(@D)/$(lib) $(1)/usr/lib/$(notdir $(lib))
		libsoname="$$( $(TARGET_READELF) -d "$(@D)/$(lib)" \
			|sed -r -e '/.*\(SONAME\).*\[(.*)\]$$/!d; s//\1/;' )"; \
		if [ -n "$${libsoname}" -a "$${libsoname}" != "$(notdir $(lib))" ]; then \
			ln -sf $(notdir $(lib)) \
				$(1)/usr/lib/$${libsoname}; \
		fi
		baseso=$(firstword $(subst .,$(space),$(notdir $(lib)))).so; \
		if [ -n "$${baseso}" -a "$${baseso}" != "$(notdir $(lib))" ]; then \
			ln -sf $(notdir $(lib)) $(1)/usr/lib/$${baseso}; \
		fi
	)
endef

# For staging, install libraries and development files
define EX_NVIDIA_DRIVER_INSTALL_STAGING_CMDS
	$(call EX_NVIDIA_DRIVER_INSTALL_LIBS,$(STAGING_DIR))
	$(EX_NVIDIA_DRIVER_INSTALL_GL_DEV)
endef

# For target, install libraries and X.org modules
define EX_NVIDIA_DRIVER_INSTALL_TARGET_CMDS
	$(call EX_NVIDIA_DRIVER_INSTALL_LIBS,$(TARGET_DIR))
	$(foreach m,$(EX_NVIDIA_DRIVER_X_MODS), \
		$(INSTALL) -D -m 0644 $(@D)/$(notdir $(m)) \
			$(TARGET_DIR)/usr/lib/xorg/modules/$(m)
	)
	$(foreach p,$(EX_NVIDIA_DRIVER_PROGS), \
		$(INSTALL) -D -m 0755 $(@D)/$(p) \
			$(TARGET_DIR)/usr/bin/$(p)
	)
	$(EX_NVIDIA_DRIVER_INSTALL_KERNEL_MODULE)
endef

$(eval $(generic-package))
