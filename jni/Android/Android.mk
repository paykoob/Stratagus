LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := application

LOCAL_SRC_FILES := Android.cpp

LOCAL_CPP_EXTENSION := .cpp

LOCAL_STATIC_LIBRARIES := stratagus sdl lua png

LOCAL_LDLIBS := -ljnigraphics -lz -ldl -llog -lGLESv1_CM

include $(BUILD_SHARED_LIBRARY)
