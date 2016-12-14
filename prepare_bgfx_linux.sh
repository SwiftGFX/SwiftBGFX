cd 3rdparty/bgfx
../bx/tools/bin/linux/ninja -C .build/projects/ninja-linux/release64 -t clean
../bx/tools/bin/linux/ninja -C .build/projects/ninja-linux/debug64 -t clean
../bx/tools/bin/linux/ninja -C .build/projects/ninja-linux/release64 bgfx
../bx/tools/bin/linux/ninja -C .build/projects/ninja-linux/debug64 bgfx
