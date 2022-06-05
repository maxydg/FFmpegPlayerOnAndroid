#!/bin/bash
echo "Enter building script"
#Specify your own NDK setup
PWD=`pwd`
API=30
ARCH=aarch64
CPU=armv8-a
NDK=/home/rzxlf2/Android/Sdk/ndk/21.4.7075529/
TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/linux-x86_64
SYSROOT=$TOOLCHAIN/sysroot
TOOL_PREFIX=$TOOLCHAIN/bin/aarch64-linux-android-
CC="$TOOLCHAIN/bin/aarch64-linux-android$API-clang"
CXX="$TOOLCHAIN/bin/aarch64-linux-android$API-clang++"
NM="$TOOLCHAIN/bin/aarch64-linux-android-nm"
FFMPEGSRC=$PWD/ffmpeg_armv8a

function buildFF
{
	echo "Start building ffmpeg"
	cd $FFMPEGSRC
	./configure \
		--prefix=$PREFIX \
		--target-os=android \
		--cross-prefix=$TOOL_PREFIX \
		--arch=$ARCH \
		--cpu=$CPU  \
		--sysroot=$SYSROOT \
		--extra-cflags="$CFLAG" \
		--cc=$CC \
		--cxx=$CXX \
		--nm=$NM \
		--enable-shared \
		--enable-runtime-cpudetect \
		--enable-gpl \
		--enable-small \
		--enable-cross-compile \
		--disable-debug \
		--disable-static \
		--disable-doc \
		--disable-ffmpeg \
		--disable-ffplay \
		--disable-ffprobe \
		--disable-postproc \
		--disable-avdevice \
		--disable-symver \
		--disable-stripping \
		$ADD 
	make -j8
	make install
	cd $PWD
	echo "Building finished!"
}
# ###########################################################
echo "Building with neon and HWCodec"
PREFIX=$PWD/android/$CPU-neon-hard
CFLAG="-I$SYSROOT/usr/include -fPIC -DANDROID -mfpu=neon -mfloat-abi=softfp "
ADD="--enable-asm \
	--enable-neon \
	--enable-jni \
	--enable-mediacodec \
	--enable-decoder=h264_mediacodec \
	--enable-hwaccel=h264_mediacodec "
buildFF

###########################################################
# echo "Building without neon and HWCodec"
# PREFIX=$PWD/android/$CPU
# CFLAG="-I$SYSROOT/usr/include -fPIC -DANDROID -mfpu=vfp -mfloat-abi=softfp "
# ADD=
# buildFF

##Reference
#https://github.com/CainKernel/FFmpegAndroid/blob/master/tools/ffmpeg/build_ffmpeg_arm64-v8a.sh
#https://github.com/cmeng-git/ffmpeg-android/blob/master/_ffmpeg_build.sh
