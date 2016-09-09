// Copyright 2016 Stuart Carnie.
// License: https://github.com/stuartcarnie/SwiftBGFX#license-bsd-2-clause
//

import Cbgfx

public enum MemoryBlockError: Error {
    case emptyBuffer
}

/// Represents a block of memory managed by the graphics API
public struct MemoryBlock {
    var handle: UnsafePointer<bgfx_memory_t>
       
    /// The pointer to the raw data
    public var data: UnsafeMutablePointer<UInt8> {
        return handle.pointee.data
    }
    
    /// The size of the block, in bytes
    public var size: UInt32 {
        return handle.pointee.size
    }

    private init(handle: UnsafePointer<bgfx_memory_t>) {
        self.handle = handle
    }
    
    /// Initializes a new memory buffer of a specific size
    public init(size: UInt32) {
        self.init(handle: bgfx_alloc(size))
    }
    
    /// Initializes a new memory buffer by copying from the source data
    ///
    /// - parameter data: the source data
    public init<T>(data: [T]) {
        self.init(handle: bgfx_copy(data, UInt32(MemoryLayout<T>.size * data.count)))
    }
    
    /// Initializes a new memory buffer by copying from the source text data
    ///
    /// - parameter text: the source text data
    public init(text: String) {
        self.init(handle: bgfx_copy(text, UInt32(text.utf8.count)))
    }
    
    /// Creates a reference to the given data
    ///
    /// - parameter data: The array to reference
    ///
    /// - returns: The native memory block referring to the data
    ///
    /// - attention: The array must not be modified for at least 2 rendered frames
    ///
    /// - precondition: The `data` must not be empty
    ///
    /// - throws: `MemoryBlockError.EmptyBuffer` if the `data` is empty
    ///
    public static func makeRef<T>(data: [T]) throws -> MemoryBlock {
        if data.count == 0 {
            throw MemoryBlockError.emptyBuffer
        }
        
        return MemoryBlock(handle: bgfx_make_ref(data, UInt32(MemoryLayout<T>.size * data.count)))
    }
}
