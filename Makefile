ifeq ($(ROOTLESS),1)
THEOS_PACKAGE_SCHEME=rootless
endif

DEBUG=0
FINALPACKAGE=1
export ARCHS = arm64
TARGET := iphone:clang:latest:13.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = PFPViewer
$(TWEAK_NAME)_FILES = $(wildcard *.x *.m YYImage/*.m)
$(TWEAK_NAME)_FRAMEWORKS = UIKit Foundation Photos
$(TWEAK_NAME)_EXTRA_FRAMEWORKS = WebP
$(TWEAK_NAME)_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
