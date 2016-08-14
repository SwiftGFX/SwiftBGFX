// Copyright 2016 Stuart Carnie.
// License: https://github.com/stuartcarnie/SwiftBGFX#license-bsd-2-clause
//

/// Represents a static index buffer
public class IndexBuffer {
    let handle: bgfx_index_buffer_handle_t
    
    /// Initializes a new static index buffer from memory
    ///
    /// - parameter memory: The 16-bit index data used to populate the buffer
    /// - parameter flags:  Flags used to control buffer behavior
    public init(memory: MemoryBlock, flags: BufferFlags = [.none]) {
        handle = bgfx_create_index_buffer(memory.handle, flags.rawValue)
    }
    
    deinit {
        bgfx_destroy_index_buffer(handle)
    }
}
