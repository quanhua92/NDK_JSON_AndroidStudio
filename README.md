Use JsonCPP with NDK in Android Studio
=======================================


Create class & setup NDK build to get String from native
------------------------------------------------------

- Create class NativeClass with function getStringFromNative:

<pre>
public class NativeClass {
    public native static String getStringFromNative();
}
</pre>

- Build project to generate classes

- Open terminal. Change to app/src/main. Then run

<pre>
javah -d jni -classpath ../../build/intermediates/classes/debug/ com.example.ndk_json_androidstudio.NativeClass
</pre>

- Create "com_example_ndk_json_androidstudio_NativeClass.cpp" in c folder (jni folder).

<pre>
#include <com_example_ndk_json_androidstudio_NativeClass.h>

JNIEXPORT jstring JNICALL Java_com_example_ndk_1opencv_1androidstudio_NativeClass_getStringFromNative
  (JNIEnv * env, jobject obj){
    return env->NewStringUTF("Hello from JNI");
}
</pre>

- Add id to TextView

<pre>
android:id="@+id/testTextView"
</pre>

- Use getStringFromNative() to change testTextView text

<pre>
    TextView tv = (TextView) findViewById(R.id.testTextView);
    tv.setText(NativeClass.getStringFromNative());
</pre>

- Open build.gradle. Add this before buildTypes

<pre>
    // begin
    sourceSets.main {
        jni.srcDirs = [] //disable automatic ndk-build call
    }
    // replace path to NDK_BUILD
    task ndkBuild(type: Exec, description: 'Compile JNI source via NDK') {
        commandLine "/home/robotbase/Android/NDK64/android-ndk-r10d/ndk-build",
                'NDK_PROJECT_PATH=build/intermediates/ndk',
                'NDK_LIBS_OUT=src/main/jniLibs',
                'APP_BUILD_SCRIPT=src/main/jni/Android.mk',
                'NDK_APPLICATION_MK=src/main/jni/Application.mk'
    }
    tasks.withType(JavaCompile) {
        compileTask -> compileTask.dependsOn ndkBuild
    }
    //end
</pre>

- Android.mk

<pre>
LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_SRC_FILES := com_example_ndk_json_androidstudio_NativeClass.cpp
LOCAL_LDLIBS += -llog
LOCAL_MODULE := MyLib

include $(BUILD_SHARED_LIBRARY)
</pre>
- Application.mk

<pre>
APP_STL := gnustl_static
APP_CPPFLAGS := -frtti -fexceptions
APP_ABI := armeabi-v7a
APP_PLATFORM := android-16
</pre>

Setup Jsoncpp
----------------------------------------

- Clone jsoncpp project

<pre>
	git clone https://github.com/open-source-parsers/jsoncpp
</pre>

- Create json.cpp file. Run in jsoncpp folder

<pre>
	python amalgamate.py
</pre>

- Copy content of folder "dist" to "jni" folder

<pre>
json/json.h
json/json-forwards.h
jsoncpp.cpp
</pre>

- Open Android.mk and edit as follow

<pre>
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
</pre>

- Edit com_example_ndk_json_androidstudio_NativeClass.cpp

<pre>
#include "com_example_ndk_json_androidstudio_NativeClass.h"
#include "json/json.h"

JNIEXPORT jstring JNICALL Java_com_example_ndk_1json_1androidstudio_NativeClass_getStringFromNative
  (JNIEnv * env, jobject obj){
//    return env->NewStringUTF("Hello from JNI");

    Json::Value jsonObject;
    jsonObject["data1"] = "this is a json object";
    jsonObject["data2"] = 8888;
    jsonObject["data3"] = 9999;


    const char* json_str = jsonObject.toStyledString().c_str();
    jstring result = env->NewStringUTF(json_str);

    return result;
}
</pre>

Reference
=======================
- http://www.phonesdevelopers.com/1798779/