MACOSX_DEPLOYMENT_TARGET=10.11 swift build -Xcc -I../3rdparty/bgfx/3rdparty/khronos \
-Xcc -I../3rdparty/bx/include -Xcc -I../3rdparty/bgfx/3rdparty \
-Xcc -I../3rdparty/bx/include/compat/osx \
-Xcc -fno-objc-arc -Xlinker -lc++ \
-Xlinker -framework -Xlinker Foundation \
-Xlinker -framework -Xlinker AppKit \
-Xlinker -L../3rdparty/bgfx/.build/osx64_clang/bin \
-Xlinker -lbgfxDebug -Xcc -DBGFX_CONFIG_RENDERER_METAL=1 \
-Xlinker -framework -Xlinker Metal -Xlinker -framework -Xlinker Quartz \
-Xlinker -framework -Xlinker MetalKit
