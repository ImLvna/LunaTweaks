TARGET := iphone:clang:latest:13.0
INSTALL_TARGET_PROCESSES = backboardd
#if on lan
#THEOS_DEVICE_IP = 192.168.1.183
#if connected over ssh tunnell
THEOS_DEVICE_IP = 127.0.0.1
THEOS_DEVICE_PORT = 2200
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = LunaTweaks

LunaTweaks_PRIVATE_FRAMEWORKS = SpringBoardServices

LunaTweaks_FILES = Tweak.xm
LunaTweaks_CFLAGS = -fobjc-arc

LunaTweaks_EXTRA_FRAMEWORKS = Cephei

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += lunatweaksprefs
SUBPROJECTS += rebootuserspace
include $(THEOS_MAKE_PATH)/aggregate.mk
