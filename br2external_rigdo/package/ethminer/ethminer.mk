#############################################################
#
# ethminer
#
#############################################################

ETHMINER_VERSION = v0.18.0
ETHMINER_SITE = https://github.com/ethereum-mining/ethminer
ETHMINER_GIT_SUBMODULES = YES
ETHMINER_SITE_METHOD = git

ETHMINER_DEPENDENCIES = libopencl

#ETHMINER_CONF_OPTS += -DHUNTER_ENABLED=OFF

#opencl
ETHMINER_CONF_OPTS += -DETHASHCL=ON
ETHMINER_CONF_OPTS += -DBINKERN=OFF

#cuda
ETHMINER_CONF_OPTS += -DETHASHCUDA=ON
CUDA_D=/home/bond/projects/c7_optix/cuda/cuda_10.1
#ETHMINER_CONF_OPTS += -DCUDA_TOOLKIT_ROOT_DIR=$(CUDA_D)
ETHMINER_CONF_OPTS += -DCUDA_TOOLKIT_ROOT_DIR=$(CUDA_D)                     
ETHMINER_CONF_OPTS += -DCMAKE_FIND_ROOT_PATH=$(CUDA_D)                      
ETHMINER_CONF_OPTS += -DCUDA_TOOLKIT_ROOT_DIR_INTERNAL=$(CUDA_D)            
ETHMINER_CONF_OPTS += -DCUDA_TOOLKIT_TARGET_DIR=$(CUDA_D)                   


#api
#ETHMINER_CONF_OPTS += -DAPICORE=OFF
ETHMINER_CONF_OPTS += -DETHDBUS=OFF

ETHMINER_CONF_OPTS += -DBUILD_SHARED_LIBS=OFF

define ETHMINER_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/ethminer/ethminer $(TARGET_DIR)/root/ethminer
endef

$(eval $(cmake-package))
