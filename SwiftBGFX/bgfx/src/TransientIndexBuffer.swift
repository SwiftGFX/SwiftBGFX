// Copyright 2016 Stuart Carnie.
// License: https://github.com/stuartcarnie/SwiftBGFX#license-bsd-2-clause
//

/// Represents a transient index buffer
///
/// - remark:
/// The contents of the buffer are valid for the current frame only.
/// You must call SetVertexBuffer with the buffer or a leak could occur.
public struct TransientIndexBuffer {
    public let data: UnsafeMutablePointer<UInt8>? = nil
    public let size: UInt32 = 0
    
    let handle: UInt16 = 0
    let startIndex: UInt32 = 0
    
    /// Checks for available space to allocate an instance buffer
    ///
    /// - parameter count: The number of 16-bit indices to allocate
    ///
    /// - returns: `true` if there is space available for the given number of indices
    public static func checkAvailableSpace(_ count: UInt32) -> Bool {
        return bgfx_check_avail_transient_index_buffer(count)
    }
}
