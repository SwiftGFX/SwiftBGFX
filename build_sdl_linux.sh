swift build -Xcc -I3rdparty/bgfx/3rdparty/khronos \
-Xcc -I3rdparty/bx/include -Xcc -I3rdparty/bgfx/3rdparty \
-Xcc -I3rdparty/bx/include/compat/osx \
-Xcc -fno-objc-arc \
-Xswiftc -DNOSIMD \
-Xlinker -L3rdparty/bgfx/.build/linux64_gcc/bin \
-Xlinker -lbgfxDebug -Xcc -DBGFX_CONFIG_RENDERER_METAL=0

