swift build -Xcc -fno-objc-arc -Xcc -DBGFX_CONFIG_RENDERER_METAL=1 \
-Xlinker -framework -Xlinker Metal    -Xlinker -framework -Xlinker Quartz \
-Xlinker -framework -Xlinker MetalKit -Xlinker -framework -Xlinker AppKit \
-Xlinker -lc++
