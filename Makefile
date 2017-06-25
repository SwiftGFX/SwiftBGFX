
SWIFT_FLAGS_COMMON = -Xswiftc -I3rdparty/bgfx/3rdparty/khronos \
-Xswiftc -I3rdparty/bx/include \
-Xswiftc -I3rdparty/bgfx/3rdparty \
-Xlinker -lc++ -Xlinker -lz \
-Xlinker -lbgfxDebug -Xlinker -lbxDebug -Xlinker -lbimgDebug

APPLE_FLAGS = -Xlinker -framework -Xlinker Foundation
IOS_FLAGS = -Xlinker -Lexternal/SwiftBGFX/3rdparty/bgfx/.build/ios-arm64/bin \
-Xlinker -framework -Xlinker OpenGLES -Xlinker -framework -Xlinker UIKit
MACOS_FLAGS = -Xlinker -framework -Xlinker AppKit -Xlinker -framework -Xlinker Quartz \
-Xlinker -L3rdparty/bgfx/.build/osx64_clang/bin \
-Xcc -I3rdparty/bx/include/compat/osx

CC_FLAGS_METAL = -Xcc -DBGFX_CONFIG_RENDERER_METAL=1
SWIFT_FLAGS_METAL = -Xlinker -framework -Xlinker Metal -Xlinker -framework -Xlinker MetalKit

macos:
	swift build $(SWIFT_FLAGS_COMMON) $(MACOS_FLAGS) $(CC_FLAGS_METAL) $(SWIFT_FLAGS_METAL) $(APPLE_FLAGS)

xcodeproj-macos:
	swift package $(SWIFT_FLAGS_COMMON) $(SWIFT_FLAGS_METAL) $(CC_FLAGS_METAL) $(MACOS_FLAGS) \
	generate-xcodeproj --output SwiftBGFX-macOS.xcodeproj
