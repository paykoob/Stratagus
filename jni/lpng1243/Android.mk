LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := png

LOCAL_SRC_FILES := \
    png.c \
    pngset.c \
    pngget.c \
    pngrutil.c \
    pngtrans.c \
    pngwutil.c \
    pngmem.c \
    pngpread.c \
    pngread.c \
    pngerror.c \
    pngwrite.c \
    pngrtran.c \
    pngwtran.c \
    pngrio.c \
    pngwio.c \

include $(BUILD_STATIC_LIBRARY)

