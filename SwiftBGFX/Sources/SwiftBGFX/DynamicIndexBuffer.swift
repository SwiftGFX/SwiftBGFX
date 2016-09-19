// Copyright 2016 Stuart Carnie.
// License: https://github.com/stuartcarnie/SwiftBGFX#license-bsd-2-clause
//

import Cbgfx

/// Represents a dynamically updateable index buffer
public class DynamicIndexBuffer {
    let handle: bgfx_dynamic_index_buffer_handle_t
    
    /// Creates a new dynamic index buffer with enough space to accommodate
	/// `indexCount` vertex indices
    ///
    /// - parameter indexCount: The number of indices that can fit in the buffer
    /// - parameter flags:      Flags used to control buffer behavior
    public init(indexCount: UInt32, flags: BufferOptions = [.none]) {
        handle = bgfx_create_dynamic_index_buffer(indexCount, flags.rawValue)
    }
    
    /// Creates a new dynamic index buffer from memory
    ///
    /// - parameter memory: The initial index data with which to populate the buffer
    /// - parameter flags:  Flags used to control buffer behavior
    public init(memory: MemoryBlock, flags: BufferOptions = [.none]) {
        handle = bgfx_create_dynamic_index_buffer_mem(memory.handle, flags.rawValue)
    }
    
    /// Updates the data in the buffer
    ///
    /// - parameter startIndex: Position of the first index to update
    /// - parameter mem: The new index data with which to fill the buffer
    public func update(startIndex: UInt32, mem: MemoryBlock) {
        bgfx_update_dynamic_index_buffer(handle, startIndex, mem.handle)
    }
    
    deinit {
        bgfx_destroy_dynamic_index_buffer(handle)
    }
}
