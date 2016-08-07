// Copyright 2016 Stuart Carnie.
// License: https://github.com/stuartcarnie/SwiftBGFX#license-bsd-2-clause
//

public class VertexBuffer {
    let handle: bgfx_vertex_buffer_handle_t
    
    public init(memory: MemoryBlock, layout: VertexLayout, flags: BufferFlags = [.None]) {
        handle = bgfx_create_vertex_buffer(memory.handle, &layout.handle, flags.rawValue)
    }
    
    deinit {
        bgfx_destroy_vertex_buffer(handle)
    }
}
