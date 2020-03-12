#!/bin/bash
export TMPDIR=/home/storm/plagin/ffmpeg/ffmpeg-3.3.9/ffmpegtemp #这句很重要，不然会报错 unable to create temporary file in
# NDK的路径，根据自己的安装位置进行设置
NDK=/home/storm/plagin/ndk/android-ndk-r14b
# 编译针对的平台，可以根据自己的需求进行设置
# 这里选择最低支持android-14, arm架构，生成的so库是放在
# libs/armeabi文件夹下的，若针对x86架构，要选择arch-x86
PLATFORM=$NDK/platforms/android-14/arch-arm
# 工具链的路径，根据编译的平台不同而不同
# arm-linux-androideabi-4.9与上面设置的PLATFORM对应，4.9为工具的版本号，
# 根据自己安装的NDK版本来确定，一般使用最新的版本
TOOLCHAIN=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64
function build_one
{
$TOOLCHAIN/bin/arm-linux-androideabi-ld \
-rpath-link=$PLATFORM/usr/lib \
-L$PLATFORM/usr/lib \
-soname libffmpeg.so -shared -nostdlib -z noexecstack -Bsymbolic --whole-archive --no-undefined -o \
$PREFIX/libffmpeg.so \
    libavcodec/libavcodec.a \
    libavfilter/libavfilter.a \
    libswresample/libswresample.a \
    libavformat/libavformat.a \
    libavutil/libavutil.a \
    libswscale/libswscale.a \
    lame/libmp3lame.a \
    -lc -lm -lz -ldl -llog --dynamic-linker=/system/bin/linker \
    $TOOLCHAIN/lib/gcc/arm-linux-androideabi/4.9.x/libgcc.a
}
# arm v7vfp
CPU=armv7-a
OPTIMIZE_CFLAGS="-mfloat-abi=softfp -mfpu=vfp -marm -march=$CPU "
PREFIX=./android/$CPU-vfp
ADDITIONAL_CONFIGURE_FLAG=
ADDI_CFLAGS="-I/home/storm/plagin/lame/lame-3.99.5/android/armv7-a/include"
ADDI_LDFLAGS="-L/home/storm/plagin/lame/lame-3.99.5/android/armv7-a/lib2"
build_one
