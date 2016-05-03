//
//  entry.swift
//  bgfx Test
//
//  Created by Stuart Carnie on 4/19/16.
//  Copyright © 2016 SGC. All rights reserved.
//

public protocol AppI {
    func startup(argc: Int, argv:[String])
    func shutdown() -> Int
    func update() -> Bool
}

var s_exit: Bool = false
var s_debug: DebugOptions = []
var s_reset: ResetOptions = []

extension AppI {
    
    public func processEvents(inout width: UInt16, inout height: UInt16, inout debug: DebugOptions, inout reset: ResetOptions) -> Bool {
        s_debug = debug
        var forceReset = reset != s_reset
        s_reset = reset
        
        while let ev = s_ctx.poll() {
            switch ev {
            case .Size(let w, let h):
                width = w
                height = h
                forceReset = true
                
            case .Exit:
                return true
                
            default:
                break
            }
        }
        
        if forceReset {
            bgfx.reset(width: width, height: height, options: s_reset)
        }
        
        return s_exit
    }
}

func runApp(app: AppI, argc: Int, argv:[String]) -> Int {
    app.startup(argc, argv: argv)
    
    while app.update() {}
    
    return app.shutdown();
}