cd 3rdparty/bgfx
../bx/tools/bin/darwin/genie --gcc=osx ninja
cd .build/projects/ninja-osx
MACOSX_DEPLOYMENT_TARGET=10.11 make config=debug64 clean
MACOSX_DEPLOYMENT_TARGET=10.11 make config=release64 clean
MACOSX_DEPLOYMENT_TARGET=10.11 make config=debug64 bgfx
MACOSX_DEPLOYMENT_TARGET=10.11 make config=release64 bgfx
