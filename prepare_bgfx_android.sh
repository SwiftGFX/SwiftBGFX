export ANDROID_NDK_ROOT=$ANDROID_NDK_HOME
export ANDROID_NDK_ARM=$ANDROID_NDK_ROOT/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64
# MIPS and x86 android are not supported at the moment
#export ANDROID_NDK_MIPS=$ANDROID_NDK_ROOT/toolchains/mipsel-linux-android-4.9/prebuilt/linux-x86_64
#export ANDROID_NDK_X86=$ANDROID_NDK_ROOT/toolchains/x86-4.9/prebuilt/linux-x86_64
#export CXXFLAGS="--stl=libc++"
#export CXX="$ANDROID_NDK_ROOT/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin/arm-linux-androideabi-clang++"
cd 3rdparty/bgfx
make
make android-arm
#& make android-mips & make android-x86
