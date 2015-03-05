APP_STL := gnustl_shared

APP_CPPFLAGS += -frtti
APP_CPPFLAGS += -fexceptions
APP_CPPFLAGS += -std=c++11

APP_ABI := armeabi-v7a
NDK_TOOLCHAIN_VERSION := 4.9