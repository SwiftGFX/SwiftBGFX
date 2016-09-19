// Copyright 2016 Stuart Carnie.
// License: https://github.com/stuartcarnie/SwiftBGFX#license-bsd-2-clause
//

import Cbgfx

/// Represents a static index buffer
public class IndexBuffer {
    let handle: bgfx_index_buffer_handle_t
    
    /// Creates a new static index buffer from memory
    ///
    /// - parameter memory: The 16-bit index data used to populate the buffer
    /// - parameter options: Options used to control buffer behavior
    public init(memory: MemoryBlock, options: BufferOptions = [.none]) {
        handle = bgfx_create_index_buffer(memory.handle, options.rawValue)
    }
    
    deinit {
        bgfx_destroy_index_buffer(handle)
    }
}
