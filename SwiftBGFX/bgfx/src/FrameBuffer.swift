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
    ///
    public init(width: UInt16, height: UInt16, format: TextureFormat, flags: TextureFlags = [.ClampU, .ClampV]) {
        handle = bgfx_create_frame_buffer(width, height, bgfx_texture_format_t(format.rawValue), flags.rawValue)
    }
    
    /// Creates a new frame buffer
    ///
    /// - parameters:
    ///
    ///     - ratio: The amount to scale when the backbuffer resizes
    ///     - format: The format of the new surface
    ///     - flags: Texture sampling flags
    ///
    /// - returns: new frame buffer
    ///
    public init(ratio: BackbufferRatio, format: TextureFormat, flags: TextureFlags = [.ClampU, .ClampV]) {
        handle = bgfx_create_frame_buffer_scaled(bgfx_backbuffer_ratio_t(ratio.rawValue), bgfx_texture_format_t(format.rawValue), flags.rawValue)
    }
    
    /// Creates a new frame buffer
    ///
    /// - warning: You must call `destroy` to clean up any resources used by the frame buffer
    ///
    /// - parameters:
    ///
    ///    - windowHandle: A reference to a native window handle
    ///    - width: The width of the render target
    ///    - height: The height of the render target
    ///    - format: A desired format for a depth buffer, if applicable
    ///
    public init(windowHandle: NativeWindowHandle, width: UInt16, height: UInt16, depthFormat: TextureFormat = .UnknownDepth) {
        handle = bgfx_create_frame_buffer_from_nwh(windowHandle, width, height, bgfx_texture_format_t(depthFormat.rawValue))
    }
    
    deinit {
        bgfx_destroy_frame_buffer(handle)
    }
    
    /// Blits the contents of the framebuffer to a texture
    ///
    /// - parameters:
    ///
    ///     - viewId: The view in which the blit will be ordered.
    ///     - dest: The destination texture.
    ///     - destX: The destination X position.
    ///     - destY: The destination Y position.
    ///     - attachment: The frame buffer attachment from which to blit
    ///     - srcX: The source X position.
    ///     - srcY: The source Y position.
    ///     - width: The width of the region to blit.
    ///     - height: The height of the region to blit.
    ///
    /// - remark: The destination texture must be created with the `TextureFlags.BlitDestination` flag
    ///
    public func blit(viewId viewId: UInt8, dest: Texture, destX: UInt16, destY: UInt16,
                            attachment: UInt8,
                            srcX: UInt16, srcY: UInt16,
                            width: UInt16, height: UInt16, depth: UInt16) {
        
        blit(viewId: viewId, dest: dest, destMip: 0, destX: destX, destY: destY, destZ: 0, attachment: attachment, srcMip: 0, srcX: srcX, srcY: srcY, srcZ: 0, width: width, height: height, depth: 0)
    }
    
    /// Blits the contents of the texture to another texture
    ///
    /// - parameters:
    ///
    ///     - viewId: The view in which the blit will be ordered.
    ///     - dest: The destination texture.
    ///     - destMip: The destination mip level.
    ///     - destX: The destination X position.
    ///     - destY: The destination Y position.
    ///     - destZ: The destination Z position.
    ///     - attachment: The frame buffer attachment from which to blit
    ///     - srcMip: The source mip level.
    ///     - srcX: The source X position.
    ///     - srcY: The source Y position.
    ///     - srcZ: The source Z position.
    ///     - width: The width of the region to blit.
    ///     - height: The height of the region to blit.
    ///     - depth: The depth of the region to blit.
    ///
    /// - remark: The destination texture must be created with the `TextureFlags.BlitDestination` flag
    ///
    public func blit(viewId viewId: UInt8, dest: Texture, destMip: UInt8, destX: UInt16, destY: UInt16, destZ: UInt16,
                            attachment: UInt8, srcMip: UInt8, srcX: UInt16, srcY: UInt16, srcZ: UInt16,
                            width: UInt16, height: UInt16, depth: UInt16) {
        
        bgfx_blit_frame_buffer(viewId, dest.handle, destMip, destX, destY, destZ, handle, attachment, srcMip, srcX, srcY, srcZ, width, height, depth)
    }
    
    /// Reads the contents of the framebuffer and stores them in memory pointed to by `data`
    ///
    /// - parameters:
    ///
    ///     - attachment: The frame buffer attachment from which to read
    ///     - data: The destination for the read image data
    ///
    /// - remark: The attachment must have been created with the `TextureFlags.ReadBack` flag
    ///
    public func read(attachment: UInt8, data: UnsafeMutablePointer<Void>) {
        bgfx_read_frame_buffer(handle, attachment, data)
    }
}