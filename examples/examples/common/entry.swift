// Copyright 2016 Stuart Carnie.
// License: https://github.com/stuartcarnie/SwiftBGFX#license-bsd-2-clause
//

import SwiftBGFX

protocol AppI {
    func startup(_ argc: Int, argv:[String])
    func shutdown() -> Int
    func update() -> Bool
}

var s_exit: Bool = false
var s_debug: DebugOptions = []
var s_reset: ResetOptions = []

internal extension AppI {
    
    internal func processEvents(_ width: inout UInt16, height: inout UInt16, debug: inout DebugOptions, reset: inout ResetOptions) -> Bool {
        s_debug = debug
        var forceReset = reset != s_reset
        s_reset = reset
        
        while let ev = s_ctx.poll() {
            switch ev {
            case .size(let w, let h):
                width = w
                height = h
                forceReset = true
                
            case .exit:
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

@discardableResult
func runApp(_ app: AppI, argc: Int, argv:[String]) -> Int {
    app.startup(argc, argv: argv)
    
    while app.update() {}
    
    return app.shutdown();
}
