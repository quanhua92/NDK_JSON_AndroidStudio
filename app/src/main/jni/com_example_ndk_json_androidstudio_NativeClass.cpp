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