//
//  vertexbuffer.swift
//  bgfx Test
//
//  Created by Stuart Carnie on 4/21/16.
//  Copyright © 2016 SGC. All rights reserved.
//

public class VertexBuffer : CustomDebugStringConvertible {
    let handle: bgfx_vertex_buffer_handle_t
    
    public init(memory: MemoryBlock, layout: VertexLayout, flags: BufferFlags = [.None]) {
        handle = bgfx_create_vertex_buffer(memory.handle, &layout.handle, flags.rawValue)
    }
    
    deinit {
        bgfx_destroy_vertex_buffer(handle)
    }
    
    public var debugDescription: String {
        return "Handle \(handle)"
    }
}