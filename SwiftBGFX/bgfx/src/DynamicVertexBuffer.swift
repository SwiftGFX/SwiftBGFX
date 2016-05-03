//
//  dynamicvertexbuffer.swift
//  bgfx Test
//
//  Created by Stuart Carnie on 4/22/16.
//  Copyright © 2016 SGC. All rights reserved.
//

/// Represents a dynamically updateable index buffer
public class DynamicVertexBuffer : CustomDebugStringConvertible {
    let handle: bgfx_dynamic_vertex_buffer_handle_t

    /// Initializes a new instance
    ///
    /// - parameters:
    ///
    ///    - vertexCount: The number of vertices that fit in the buffer
    ///    - layout: The layout of the vertex data
    ///    - flags: Flags used to control buffer behavior
    public init(vertexCount: UInt32, layout: VertexLayout, flags: BufferFlags = [.None]) {
        handle = bgfx_create_dynamic_vertex_buffer(vertexCount, &layout.handle, flags.rawValue)
    }
    
    /// Initializes a new instance
    ///
    /// - parameters:
    ///
    ///    - memory: The initial vertex data with which to populate the buffer
    ///    - layout: The layout of the vertex data
    ///    - flags: Flags used to control buffer behavior
    public init(memory: MemoryBlock, layout: VertexLayout, flags: BufferFlags = [.None]) {
        handle = bgfx_create_dynamic_vertex_buffer_mem(memory.handle, &layout.handle, flags.rawValue)
    }
    
    /// Updates the data in the buffer
    ///
    /// - parameters:
    ///
    ///     - startIndex: Position of the first index to update
    ///     - mem: The new index data with which to fill the buffer
    public func update(startIndex: UInt32, mem: MemoryBlock) {
        bgfx_update_dynamic_vertex_buffer(handle, startIndex, mem.handle)
    }
    
    deinit {
        bgfx_destroy_dynamic_vertex_buffer(handle)
    }
    
    public var debugDescription: String {
        return "Handle \(handle)"
    }
}