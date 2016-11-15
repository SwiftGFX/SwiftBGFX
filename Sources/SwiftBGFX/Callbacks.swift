// Copyright 2016 Stuart Carnie.
// License: https://github.com/stuartcarnie/SwiftBGFX#license-bsd-2-clause
//

import Cbgfx

/// Provides an interface for programs to respond to callbacks from the bgfx library
public protocol Callbacks {
    
    /// Called when an error occurs in the library
    ///
    /// - parameter type: The type of error that occurred
    /// - parameter message: Message string detailing what went wrong
    ///
    /// - remark:
    /// If the error type is not `ErrorType.DebugCheck`, bgfx is in an
    /// unrecoverable state and the application should terminate
    ///
    /// This method can be called from any thread
    ///
    func reportError(_ type: BgfxError, message: String)
    
    /// Called to print debug messages
    ///
    ///  - parameter fileName: The name of the source file in which the message originated
    ///  - parameter line: The line number in which the message originated
    ///  - parameter format: The message format string
    ///     
    /// - remark: This method can be called from any thread
    ///
    func reportDebug(_ fileName: String, line: UInt16, format: String)
}

private var callbacks: Callbacks?
private var vtablep: UnsafeMutablePointer<bgfx_callback_vtbl_t>?
private var cbip: UnsafeMutablePointer<bgfx_callback_interface_t>?

internal func makeCallbackHandler(_ cb: Callbacks) -> UnsafeMutablePointer<bgfx_callback_interface_t> {
    cleanupCallbackHandler()
    callbacks = cb

    var vt = bgfx_callback_vtbl_t()
    
    // setup callbacks
    vt.fatal = { (a: UnsafeMutablePointer<bgfx_callback_interface_t>?, b: bgfx_fatal_t, c: UnsafePointer<Int8>?) in
        callbacks!.reportError(BgfxError(rawValue: b.rawValue)!, message: String(cString: c!))
    }
    
    // TODO: implement shim in C in order to unpack va_list
    vt.trace_vargs = { (a: UnsafeMutablePointer<bgfx_callback_interface_t>?,
        path: UnsafePointer<Int8>?, line: UInt16, format: UnsafePointer<Int8>?, args: CVaListPointer) in
        callbacks!.reportDebug(String(cString: path!), line: line, format: String(cString: format!))
    }

    vtablep = UnsafeMutablePointer<bgfx_callback_vtbl_t>.allocate(capacity: 1)
    vtablep?.initialize(to: vt)
    
    cbip = UnsafeMutablePointer<bgfx_callback_interface_t>.allocate(capacity: 1)
    cbip!.initialize(to: bgfx_callback_interface_t(vtbl: vtablep!))
    
    return cbip!
}

internal func cleanupCallbackHandler() {
    if let cbi = cbip {
        cbi.deinitialize()
        cbi.deallocate(capacity: 1)
        cbip = nil
    }
    
    if let vtable = vtablep {
        vtable.deinitialize()
        vtable.deallocate(capacity: 1)
        vtablep = nil
    }
    
    callbacks = nil
}
