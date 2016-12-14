cd 3rdparty/bgfx
# You will need to manually add -fPIC flags to generated ninja files at this point
# Bug has to be fixed in GENie project
../bx/tools/bin/linux/genie --with-sdl --gcc=linux-gcc ninja
../bx/tools/bin/linux/ninja -C .build/projects/ninja-linux/release64 -t clean
../bx/tools/bin/linux/ninja -C .build/projects/ninja-linux/debug64 -t clean
../bx/tools/bin/linux/ninja -C .build/projects/ninja-linux/release64 bgfx
../bx/tools/bin/linux/ninja -C .build/projects/ninja-linux/debug64 bgfx
