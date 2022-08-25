TARGET := iphone:clang:latest:7.0
INSTALL_TARGET_PROCESSES = SpringBoard
#if on lan
#THEOS_DEVICE_IP = 192.168.1.183
#if connected over ssh tunnell
THEOS_DEVICE_IP = 127.0.0.1
THEOS_DEVICE_PORT = 2200
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = LunaTweaks

LunaTweaks_FILES = Tweak.xm
LunaTweaks_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += lunatweaksprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
