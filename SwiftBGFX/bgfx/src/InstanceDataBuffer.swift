// Copyright 2016 Stuart Carnie.
// License: https://github.com/stuartcarnie/SwiftBGFX#license-bsd-2-clause
//

/// Maintains a data buffer that contains instancing data
public class InstanceDataBuffer {
    let handle: UnsafePointer<bgfx_instance_data_buffer_t>
    
    /// A pointer that can be filled with instance data
    public var data: UnsafeMutablePointer<UInt8> {
        return handle.pointee.data
    }
    
    /// The size of the data buffer
    public var size: UInt32 {
        return handle.pointee.size
    }
    
    /// Initializes a new instance buffer
    ///
    /// - parameters:
    ///
    ///    - count: The number of elements in the buffer
    ///    - stride: The stride of each element
    ///
    public init(count: Int, stride: Int) {
        handle = bgfx_alloc_instance_data_buffer(UInt32(count), UInt16(stride))
    }
    
    /// Checks for available space to allocate an instance buffer
    ///
    /// - parameters:
    ///
    ///    - count: The number of elements to allocate
    ///    - stride: The stride of each element
    ///
    /// - returns: `true` if there is space available to allocate the buffer
    ///
    public static func checkAvailableSpace(_ count: UInt32, stride: UInt16) -> Bool {
        return bgfx_check_avail_instance_data_buffer(count, stride)
    }
}
