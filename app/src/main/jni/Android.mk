LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := jsoncpp
LOCAL_CPPFLAGS := -fexceptions
LOCAL_SRC_FILES := jsoncpp.cpp
LOCAL_C_INCLUDES := $(LOCAL_PATH)/json
LOCAL_LDLIBS := -L$(call host-path, $(LOCAL_PATH)/../../libs/armeabi)
include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := com_example_ndk_json_androidstudio_NativeClass.cpp
LOCAL_LDLIBS += -llog
LOCAL_MODULE := MyLib

# include jsoncpp
LOCAL_C_INCLUDES := $(LOCAL_PATH)/json
LOCAL_SHARED_LIBRARIES := jsoncpp

include $(BUILD_SHARED_LIBRARY)