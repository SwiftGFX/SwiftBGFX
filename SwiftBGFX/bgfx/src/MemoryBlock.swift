//
//  memorybloc.swift
//  bgfx Test
//
//  Created by Stuart Carnie on 4/21/16.
//  Copyright © 2016 SGC. All rights reserved.
//

import Foundation

public enum MemoryBlockError: ErrorProtocol {
    case emptyBuffer
}

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
    
    /// Creates a memory buffer of the specified `size`
    public init(size: UInt32) {
        self.init(handle: bgfx_alloc(size))
    }
    
    public init<T>(data: [T]) {
        self.init(handle: bgfx_copy(data, UInt32(sizeof(T) * data.count)))
    }
    
    public init(text: String) {
        self.init(handle: bgfx_copy(text, UInt32(text.lengthOfBytes(using: String.Encoding.ascii))))
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
    public static func makeRef<T>(_ data: [T]) throws -> MemoryBlock {
        if data.count == 0 {
            throw MemoryBlockError.emptyBuffer
        }
        
        return MemoryBlock(handle: bgfx_make_ref(data, UInt32(sizeof(T) * data.count)))
    }
}
