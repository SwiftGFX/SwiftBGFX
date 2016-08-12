// Copyright 2016 Stuart Carnie.
// License: https://github.com/stuartcarnie/SwiftBGFX#license-bsd-2-clause
//

import SwiftMath

class HelloWorld: AppI {
    private var width: UInt16 = 1280
    private var height: UInt16 = 720
    private var debug: DebugOptions = [.text]
    private var reset: ResetOptions = [.vsync]

    func startup(_ argc: Int, argv: [String]) {
        bgfx.initialize()

        bgfx.reset(width: width, height: height, options: reset)
        bgfx.debug = debug
        bgfx.setViewClear(0, options: [.color, .depth], rgba: 0x30_30_30_ff, depth: 1.0, stencil: 0)
    }

    func shutdown() -> Int {
        bgfx.shutdown()

        return 0
    }

    func update() -> Bool {
        if !processEvents(&width, height: &height, debug: &debug, reset: &reset) {
            // Set view 0 default viewport.
            bgfx.setViewRect(0, x: 0, y: 0, width: width, height: height)
            bgfx.touch(0)

            bgfx.debugTextClear()

            bgfx.debugTextImage(x: 20, y: 20, width: 40, height: 12, data: logo, pitch: 160)
            bgfx.debugTextPrint(x: 0, y: 1, foreColor: .white, backColor: .blue, string: "bgfx/examples/00-helloworld")
            bgfx.debugTextPrint(x: 0, y: 2, foreColor: .white, backColor: .cyan, string: "Description: Initialization and debug text.")

            bgfx.frame()

            return true
        }

        return false
    }
}

public var sharedApp: AppI {
    return HelloWorld()
}

main()
