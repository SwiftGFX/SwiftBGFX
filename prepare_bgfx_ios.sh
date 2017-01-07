cd 3rdparty/bgfx
../bx/tools/bin/darwin/genie --gcc=ios-arm64 ninja
cd .build/projects/ninja-ios-arm64
make config=debug clean
make config=release clean
make config=debug bgfx
make config=release bgfx
