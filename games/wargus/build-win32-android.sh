#!/bin/sh
VERSION=1.2

LIBPNG_DIR="../../jni/lpng1243"

CFLAGS="-O2 -W -Wall -Wsign-compare -fsigned-char -mno-cygwin -I$LIBPNG_DIR -DVERSION=\"\\\"$VERSION\\\"\""
LDFLAGS="-static -mno-cygwin -L$LIBPNG_DIR"

CURRENT_DIR=`pwd`

cd $LIBPNG_DIR
make -f scripts/makefile.cygwin static MINGW=true

cd $CURRENT_DIR
make clean
make wartool pudconvert CFLAGS="$CFLAGS" LDFLAGS="$LDFLAGS"
strip wartool pudconvert
upx -9 wartool.exe pudconvert.exe
make wargus CFLAGS="$CFLAGS" LDFLAGS="$LDFLAGS"
strip wargus
upx -9 wargus.exe

makensis -DVERSION="$VERSION" wargus-android.nsi
makensis -DVERSION="$VERSION" -DAMD64 wargus-android.nsi

cd $LIBPNG_DIR
make -f scripts/makefile.cygwin clean

