//
//  indexbuffer.swift
//  bgfx Test
//
//  Created by Stuart Carnie on 4/21/16.
//  Copyright © 2016 SGC. All rights reserved.
//

/// Represents a static index buffer
public class IndexBuffer : CustomDebugStringConvertible {
    let handle: bgfx_index_buffer_handle_t
    
    public init(memory: MemoryBlock, flags: BufferFlags = [.None]) {
        handle = bgfx_create_index_buffer(memory.handle, flags.rawValue)
    }
    
    deinit {
        bgfx_destroy_index_buffer(handle)
    }
    
    public var debugDescription: String {
        return "Handle \(handle)"
    }
}