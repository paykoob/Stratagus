LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := stratagus

LOCAL_C_INCLUDES := \
    $(LOCAL_PATH)/src/include \
    $(LOCAL_PATH)/src/guichan/include \
    $(LOCAL_PATH)/../SDL-1.2.14/include \
    $(LOCAL_PATH)/../lua-5.1.4-2/src \
    $(LOCAL_PATH)/../lpng1243 \

LOCAL_CFLAGS := \
	-fsigned-char \
    -DUSE_GLES -D_GNU_SOURCE=1 -D_REENTRANT -DUSE_ZLIB \
	-DDYNAMIC_LOAD \
#    -DDEBUG

STRATAGUS_SRCS := \
    src/action/*.cpp \
    src/ai/*.cpp \
    src/editor/*.cpp \
    src/game/*.cpp \
    src/guichan/*.cpp \
    src/guichan/sdl/*.cpp \
    src/guichan/widgets/*.cpp \
    src/map/*.cpp \
    src/network/*.cpp \
    src/particle/*.cpp \
    src/pathfinder/*.cpp \
    src/sound/*.cpp \
    src/stratagus/*.cpp \
    src/tolua/*.cpp \
    src/ui/*.cpp \
    src/unit/*.cpp \
    src/video/*.cpp \

LOCAL_CPP_EXTENSION := .cpp

LOCAL_SRC_FILES := $(foreach F, $(STRATAGUS_SRCS), $(addprefix $(dir $(F)),$(notdir $(wildcard $(LOCAL_PATH)/$(F)))))

include $(BUILD_STATIC_LIBRARY)
