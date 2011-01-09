/* //device/apps/Quake/quake/src/QW/client/main.c
**
** Copyright 2007, The Android Open Source Project
**
** Licensed under the Apache License, Version 2.0 (the "License");
** you may not use this file except in compliance with the License.
** You may obtain a copy of the License at
**
**     http://www.apache.org/licenses/LICENSE-2.0
**
** Unless required by applicable law or agreed to in writing, software
** distributed under the License is distributed on an "AS IS" BASIS,
** WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
** See the License for the specific language governing permissions and
** limitations under the License.
*/
#include <jni.h>
#include <android/log.h>
#define LOGI(...) __android_log_print(ANDROID_LOG_INFO, "Stratagus", __VA_ARGS__)

#include <android/bitmap.h>

#include <stdio.h>
#include <assert.h>
#include <dlfcn.h>

#include <string>

static const char *classPathName = "com/drodin/stratagus/NativeThread";

JNIEnv* jvmEnv;
jclass nativeClass;
jmethodID blitBitmap, getKey, getTouch;

jobject mBitmap;

int mWidth, mHeight;

extern int mainStratagus(int argc, char **argv);


void
qthread(JNIEnv *env, jobject thiz, jstring dataDir, jobject bitmap) {
    int ret;
    AndroidBitmapInfo info;

    mBitmap = bitmap;

    jvmEnv = env;
    nativeClass = env->FindClass(classPathName);
    blitBitmap = env->GetStaticMethodID(nativeClass, "blitBitmap", "()V");
    getKey = env->GetStaticMethodID(nativeClass, "getKey", "()I");
    getTouch = env->GetStaticMethodID(nativeClass, "getTouch", "()I");

    if ((ret = AndroidBitmap_getInfo(env, bitmap, &info)) < 0) {
        LOGI("AndroidBitmap_getInfo() failed ! error=%d", ret);
        return;
    }

    if (info.format != ANDROID_BITMAP_FORMAT_RGB_565) {
        LOGI("Bitmap format is not RGB_565 !");
        return;
    }

    mWidth = info.width;
    mHeight = info.height;

    jboolean isCopy;
    char *ddir = (char*) env->GetStringUTFChars(dataDir, &isCopy);

    int argc = 3;
    char * argv[] = { "stratagus", "-d", ddir };
    
    mainStratagus(argc, argv);
}

static JNINativeMethod methods[] = {
  {"nativeThread", "(Ljava/lang/String;Landroid/graphics/Bitmap;)V", (void*)qthread },
};

/*
 * Register several native methods for one class.
 */
static int registerNativeMethods(JNIEnv* env, const char* className,
    JNINativeMethod* gMethods, int numMethods)
{
    jclass clazz;

    clazz = env->FindClass(className);
    if (clazz == NULL) {
        fprintf(stderr,
            "Native registration unable to find class '%s'\n", className);
        return JNI_FALSE;
    }
    if (env->RegisterNatives(clazz, gMethods, numMethods) < 0) {
        fprintf(stderr, "RegisterNatives failed for '%s'\n", className);
        return JNI_FALSE;
    }

    return JNI_TRUE;
}

/*
 * Register native methods for all classes we know about.
 */
static int registerNatives(JNIEnv* env)
{
  if (!registerNativeMethods(env, classPathName,
                 methods, sizeof(methods) / sizeof(methods[0]))) {
    return JNI_FALSE;
  }

  return JNI_TRUE;
}

/*
 * Set some test stuff up.
 *
 * Returns the JNI version on success, -1 on failure.
 */

typedef union {
    JNIEnv* env;
    void* venv;
} UnionJNIEnvToVoid;

jint JNI_OnLoad(JavaVM* vm, void* reserved)
{
    UnionJNIEnvToVoid uenv;
    uenv.venv = NULL;
    jint result = -1;
    JNIEnv* env = NULL;

    if (vm->GetEnv(&uenv.venv, JNI_VERSION_1_4) != JNI_OK) {
        fprintf(stderr, "ERROR: GetEnv failed\n");
        goto bail;
    }
    env = uenv.env;

    assert(env != NULL);

    printf("In mgmain JNI_OnLoad\n");

    if (!registerNatives(env)) {
        fprintf(stderr, "ERROR: quakemaster native registration failed\n");
        goto bail;
    }

    /* success -- return valid version number */
    result = JNI_VERSION_1_4;

bail:
    return result;
}
