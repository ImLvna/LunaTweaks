TARGET := iphone:clang:latest:7.0

include $(THEOS)/makefiles/common.mk

TOOL_NAME = rebootuserspace

rebootuserspace_FILES = main.m
rebootuserspace_CFLAGS = -fobjc-arc
rebootuserspace_CODESIGN_FLAGS = -Sentitlements.plist
rebootuserspace_INSTALL_PATH = /usr/local/bin

include $(THEOS_MAKE_PATH)/tool.mk