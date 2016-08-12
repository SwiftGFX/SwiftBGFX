// Copyright 2016 Stuart Carnie.
// License: https://github.com/stuartcarnie/SwiftBGFX#license-bsd-2-clause
//

/// Represents a dynamically updateable index buffer
public class DynamicIndexBuffer {
    let handle: bgfx_dynamic_index_buffer_handle_t
    
    public init(indexCount: UInt32, flags: BufferFlags = [.none]) {
        handle = bgfx_create_dynamic_index_buffer(indexCount, flags.rawValue)
    }
    
    public init(memory: MemoryBlock, flags: BufferFlags = [.none]) {
        handle = bgfx_create_dynamic_index_buffer_mem(memory.handle, flags.rawValue)
    }
    
    /// Updates the data in the buffer
    ///
    /// - parameters:
    ///
    ///    - startIndex: Position of the first index to update
    ///    - mem: The new index data with which to fill the buffer
    public func update(_ startIndex: UInt32, mem: MemoryBlock) {
        bgfx_update_dynamic_index_buffer(handle, startIndex, mem.handle)
    }
    
    deinit {
        bgfx_destroy_dynamic_index_buffer(handle)
    }
}
