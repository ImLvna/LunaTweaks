TARGET := iphone:clang:latest:7.0

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = lunatweaksprefs

lunatweaksprefs_FILES = XXXRootListController.m
lunatweaksprefs_FRAMEWORKS = UIKit
lunatweaksprefs_EXTRA_FRAMEWORKS = Cephei
lunatweaksprefs_PRIVATE_FRAMEWORKS = Preferences
lunatweaksprefs_INSTALL_PATH = /Library/PreferenceBundles
lunatweaksprefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
