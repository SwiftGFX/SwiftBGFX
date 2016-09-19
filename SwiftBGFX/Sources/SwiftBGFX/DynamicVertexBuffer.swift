// Copyright 2016 Stuart Carnie.
// License: https://github.com/stuartcarnie/SwiftBGFX#license-bsd-2-clause
//

import Cbgfx

/// Represents a dynamically updateable index buffer
public class DynamicVertexBuffer {
    let handle: bgfx_dynamic_vertex_buffer_handle_t

    /// Creates a new dynamic vertex buffer
    ///
    /// - parameter vertexCount: The number of vertices that fit in the buffer
    /// - parameter layout: The layout of the vertex data
    /// - parameter flags: Flags used to control buffer behavior
    public init(vertexCount: UInt32, layout: VertexLayout, flags: BufferOptions = [.none]) {
        handle = bgfx_create_dynamic_vertex_buffer(vertexCount, &layout.handle, flags.rawValue)
    }
    
    /// Creates a new dynamic vertex buffer
    ///
    /// - parameter memory: The initial vertex data with which to populate the buffer
    /// - parameter layout: The layout of the vertex data
    /// - parameter flags: Flags used to control buffer behavior
    public init(memory: MemoryBlock, layout: VertexLayout, flags: BufferOptions = [.none]) {
        handle = bgfx_create_dynamic_vertex_buffer_mem(memory.handle, &layout.handle, flags.rawValue)
    }
    
    /// Updates the data in the buffer
    ///
    /// - parameter startIndex: Position of the first index to update
    /// - parameter mem: The new index data with which to fill the buffer
    public func update(startIndex: UInt32, mem: MemoryBlock) {
        bgfx_update_dynamic_vertex_buffer(handle, startIndex, mem.handle)
    }
    
    deinit {
        bgfx_destroy_dynamic_vertex_buffer(handle)
    }
}
