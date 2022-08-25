TARGET := iphone:clang:latest:7.0
INSTALL_TARGET_PROCESSES = SpringBoard
THEOS_DEVICE_IP = localhost
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = LunaTweaks

LunaTweaks_FILES = Tweak.xm
LunaTweaks_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += lunatweaksprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
