//
//  transientvertexbuffer.swift
//  bgfx Test
//
//  Created by Stuart Carnie on 4/22/16.
//  Copyright © 2016 SGC. All rights reserved.
//

/// **
/// Represents a transient index buffer
///
/// - remark:
/// The contents of the buffer are valid for the current frame only.
/// You must call SetVertexBuffer with the buffer or a leak could occur.
/// */
public struct TransientVertexBuffer {
    // - NOTE: This structure must match the layout of bgfx_transient_vertex_buffer_t
    
    public let data: UnsafeMutablePointer<UInt8> = nil
    public let size: UInt32 = 0
    let startVertex: UInt32 = 0
    let stride: UInt16 = 0
    let handle: UInt16 = 0
    let decl: UInt16 = 0
    
    /// Checks for available space to allocate an instance buffer
    ///
    /// - parameters:
    ///
    /// - count: The number of 16-bit indices to allocate
    ///
    /// - returns: `true` if there is space available for the given number of indices
    public static func checkAvailableSpace(count: UInt32, layout: VertexLayout) -> Bool {
        return bgfx_check_avail_transient_vertex_buffer(count, &layout.handle)
    }
}
