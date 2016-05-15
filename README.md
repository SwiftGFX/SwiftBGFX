SwiftBGFX
=========

Swift bindings to [bgfx](https://github.com/bkaradzic/bgfx), a cross-platform, graphics API agnostic, "Bring Your Own Engine/Framework" style rendering library.

Status
------

This framework is currently in alpha and it should be noted that the public API is still subject to change, particularly as I move further away from the C bindings towards idiomatic Swift.

The examples are in a barely working state, to exercise the bindings, however these will be improved. I would 

**Swift Package Manager**

I also plan to use the Swift Package Manager and file bugs if there are any issues. Recently, support landed for [compiling C](http://ankit.im/swift/2016/04/06/compiling-and-interpolating-C-using-swift-package-manager/).


Fetching
--------

    $ git clone --recursive https://github.com/stuartcarnie/SwiftBGFX.git


Building
--------

### OS X

Build bgfx library

    $ cd SwiftBGFX/3rdparty/bgfx+
    $ make -j 8 osx


build Math package

    $ cd SwiftBGFX/3rdparty/Math
    $ swift build

Open workspace and build / run example

Examples
--------

* 00-helloworld
* 01-cubes
* 05-instancing

**Note:**

Before running the examples, edit the scheme and configure the `BGFX_RUNTIME_PATH` environment variable to the full path of `3rdparty/bgfx/examples/runtime`, to ensure the assets can be found. I'll fix this in a future update.