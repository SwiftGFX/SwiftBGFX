//
//  main.swift
//  bgfx Test
//
//  Created by Stuart Carnie on 4/19/16.
//  Copyright © 2016 SGC. All rights reserved.
//

import simd

class HelloWorld: AppI {
    private var width: UInt16 = 1280
    private var height: UInt16 = 720
    private var debug: DebugOptions = [.Text]
    private var reset: ResetOptions = [.VSync]

    func startup(_ argc: Int, argv: [String]) {
        bgfx.initialize()

        bgfx.reset(width: width, height: height, options: reset)
        bgfx.debug = debug
        bgfx.setViewClear(0, options: [.Color, .Depth], rgba: 0x30_30_30_ff, depth: 1.0, stencil: 0)
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
