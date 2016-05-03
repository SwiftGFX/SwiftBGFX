//
//  framebuffer.swift
//  bgfx Test
//
//  Created by Stuart Carnie on 4/21/16.
//  Copyright © 2016 SGC. All rights reserved.
//

/// An aggregated frame buffer, with one or more attached texture surfaces
public class FrameBuffer {
    let handle: bgfx_frame_buffer_handle_t
    
    static public let InvalidHandle = FrameBuffer(handle: bgfx_frame_buffer_handle_t(idx: UInt16.max))
    
    init(handle: bgfx_frame_buffer_handle_t) {
        self.handle = handle
    }
    
    /// Creates a new frame buffer
    ///
    /// - warning: You must call `destroy` to clean up any resources used by the frame buffer
    ///
    /// - parameters:
    ///
    ///    - width: The width of the render target
    ///    - height: The height of the render target
    ///    - format: The format of the new surface
    ///    - flags: Texture sampling flags
    ///
    /// - returns: new frame buffer
    public init(width: UInt16, height: UInt16, format: TextureFormat, flags: TextureFlags = [.ClampU, .ClampV]) {
        handle = bgfx_create_frame_buffer(width, height, bgfx_texture_format_t(format.rawValue), flags.rawValue)
    }
    
    deinit {
        bgfx_destroy_frame_buffer(handle)
    }
}