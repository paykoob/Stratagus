#!/bin/sh
VERSION=1.0

LIBPNG_DIR="../../jni/lpng1243"

CFLAGS="-O2 -W -Wall -fsigned-char -mno-cygwin -I$LIBPNG_DIR -DVERSION=\"\\\"$VERSION\\\"\""
LDFLAGS="-static -mno-cygwin -L$LIBPNG_DIR"

CURRENT_DIR=`pwd`

cd $LIBPNG_DIR
make -f scripts/makefile.cygwin static MINGW=true

cd $CURRENT_DIR
make clean
make startool scmconvert ARCH32="" CFLAGS="$CFLAGS" LDFLAGS="$LDFLAGS"
strip startool scmconvert
upx -9 startool.exe scmconvert.exe
make stargus ARCH32="" CFLAGS="$CFLAGS" LDFLAGS="$LDFLAGS"
strip stargus
upx -9 stargus.exe

makensis -DVERSION="$VERSION" stargus-android.nsi
makensis -DVERSION="$VERSION" -DAMD64 stargus-android.nsi

cd $LIBPNG_DIR
make -f scripts/makefile.cygwin clean
