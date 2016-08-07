// Copyright 2016 Stuart Carnie.
// License: https://github.com/stuartcarnie/SwiftBGFX#license-bsd-2-clause
//

/// Represents a static index buffer
public class IndexBuffer {
    let handle: bgfx_index_buffer_handle_t
    
    public init(memory: MemoryBlock, flags: BufferFlags = [.None]) {
        handle = bgfx_create_index_buffer(memory.handle, flags.rawValue)
    }
    
    deinit {
        bgfx_destroy_index_buffer(handle)
    }
}
