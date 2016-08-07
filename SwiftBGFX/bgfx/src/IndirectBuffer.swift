// Copyright 2016 Stuart Carnie.
// License: https://github.com/stuartcarnie/SwiftBGFX#license-bsd-2-clause
//

/// Represents a buffer that can contain indirect drawing commands created and processed entirely on the GPU
public class IndirectBuffer {
    let handle: bgfx_indirect_buffer_handle_t
    
    public init(size: UInt32) {
        handle = bgfx_create_indirect_buffer(size)
    }
    
    deinit {
        bgfx_destroy_indirect_buffer(handle)
    }
}
