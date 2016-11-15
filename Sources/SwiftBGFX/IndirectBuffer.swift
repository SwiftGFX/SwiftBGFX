// Copyright 2016 Stuart Carnie.
// License: https://github.com/stuartcarnie/SwiftBGFX#license-bsd-2-clause
//

import Cbgfx

/// Represents a buffer that can contain indirect drawing commands created and processed entirely on the GPU
public class IndirectBuffer {
    let handle: bgfx_indirect_buffer_handle_t
    
    /// Creates a new indirect buffer of a certain size
    ///
    /// - parameter size: The number of commands that can fit in the buffer
    public init(size: UInt32) {
        handle = bgfx_create_indirect_buffer(size)
    }
    
    deinit {
        bgfx_destroy_indirect_buffer(handle)
    }
}
