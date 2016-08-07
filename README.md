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


License (BSD 2-clause)
----------------------

Copyright 2016 Stuart Carnie. All rights reserved.

https://github.com/stuartcarnie/SwiftBGFX

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

   1. Redistributions of source code must retain the above copyright notice,
      this list of conditions and the following disclaimer.

   2. Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY COPYRIGHT HOLDER ``AS IS'' AND ANY EXPRESS OR
IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
EVENT SHALL COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

