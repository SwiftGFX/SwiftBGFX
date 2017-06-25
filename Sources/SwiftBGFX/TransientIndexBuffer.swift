// Copyright 2016 Stuart Carnie.
// License: https://github.com/stuartcarnie/SwiftBGFX#license-bsd-2-clause
//

import Cbgfx

/// Represents a transient index buffer
///
/// - remark:
/// The contents of the buffer are valid for the current frame only.
/// You must call SetVertexBuffer with the buffer or a leak could occur.
public struct TransientIndexBuffer {
    internal var buffer: bgfx_transient_index_buffer
    
    public var data: UnsafeMutablePointer<UInt8> {
        return buffer.data!
    }
    
    public var size: UInt32 {
        return buffer.size
    }
    
    public init(count: UInt32) {
        buffer = bgfx_transient_index_buffer()
        bgfx_alloc_transient_index_buffer(&buffer, count)
    }
    
    /// Returns number of available indices.
    ///
    /// - parameter num: Number of required indices
    ///
    /// - returns: number of available indices.
    public static func getAvailableSpace(for num: UInt32) -> UInt32 {
        return bgfx_get_avail_transient_index_buffer(num)
    }
}
