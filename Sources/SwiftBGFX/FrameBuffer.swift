// Copyright 2016 Stuart Carnie.
// License: https://github.com/stuartcarnie/SwiftBGFX#license-bsd-2-clause
//

import Cbgfx

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
    /// - parameter width: The width of the render target
    /// - parameter height: The height of the render target
    /// - parameter format: The format of the new surface
    /// - parameter options: Texture sampling options
    ///
    /// - returns: new frame buffer
    ///
    public init(width: UInt16, height: UInt16, format: TextureFormat, options: TextureOptions = [.clampU, .clampV]) {
        handle = bgfx_create_frame_buffer(width, height, bgfx_texture_format_t(format.rawValue), options.rawValue)
    }
    
    /// Creates a new frame buffer
    ///
    /// - parameter ratio: The amount to scale when the backbuffer resizes
    /// - parameter format: The format of the new surface
    /// - parameter options: Texture sampling options
    ///
    /// - returns: new frame buffer
    ///
    public init(ratio: BackbufferRatio, format: TextureFormat, options: TextureOptions = [.clampU, .clampV]) {
        handle = bgfx_create_frame_buffer_scaled(bgfx_backbuffer_ratio_t(ratio.rawValue), bgfx_texture_format_t(format.rawValue), options.rawValue)
    }
    
    /// Creates a new frame buffer
    ///
    /// - warning: You must call `destroy` to clean up any resources used by the frame buffer
    ///
    /// - parameter windowHandle: A reference to a native window handle
    /// - parameter width: The width of the render target
    /// - parameter height: The height of the render target
    /// - parameter format: A desired format for a depth buffer, if applicable
    ///
    public init(windowHandle: NativeWindowHandle, width: UInt16, height: UInt16, depthFormat: TextureFormat = .unknownDepth) {
        handle = bgfx_create_frame_buffer_from_nwh(windowHandle, width, height, bgfx_texture_format_t(depthFormat.rawValue))
    }
    
    
    /// Creates a new frame buffer using textures
    ///
    /// - parameter textures:        the source textures for the frame buffer
    /// - parameter destroyTextures: if true, textures will be destroyed when the frame buffer is destroyed
    ///
    public init(textures: [Texture], destroyTextures: Bool) {
        var handles = textures.map { $0.handle }
        handle = bgfx_create_frame_buffer_from_handles(UInt8(handles.count), &handles, destroyTextures)
    }
    
    deinit {
        bgfx_destroy_frame_buffer(handle)
    }
    
    /// Blits the contents of the framebuffer to a texture
    ///
    /// - parameter viewId: The view in which the blit will be ordered.
    /// - parameter dest: The destination texture.
    /// - parameter destX: The destination X position.
    /// - parameter destY: The destination Y position.
    /// - parameter attachment: The frame buffer attachment from which to blit
    /// - parameter srcX: The source X position.
    /// - parameter srcY: The source Y position.
    /// - parameter width: The width of the region to blit.
    /// - parameter height: The height of the region to blit.
    ///
    /// - remark: The destination texture must be created with the `TextureOptions.BlitDestination` flag
    ///
    public func blit(viewId: UInt8, dest: Texture, destX: UInt16, destY: UInt16,
                     attachment: UInt8,
                     srcX: UInt16, srcY: UInt16,
                     width: UInt16, height: UInt16, depth: UInt16) {
        
        blit(viewId: viewId, dest: dest, destMip: 0, destX: destX, destY: destY, destZ: 0, attachment: attachment, srcMip: 0, srcX: srcX, srcY: srcY, srcZ: 0, width: width, height: height, depth: 0)
    }
    
    /// Blits the contents of the texture to another texture
    ///
    /// - parameter viewId: The view in which the blit will be ordered.
    /// - parameter dest: The destination texture.
    /// - parameter destMip: The destination mip level.
    /// - parameter destX: The destination X position.
    /// - parameter destY: The destination Y position.
    /// - parameter destZ: The destination Z position.
    /// - parameter attachment: The frame buffer attachment from which to blit
    /// - parameter srcMip: The source mip level.
    /// - parameter srcX: The source X position.
    /// - parameter srcY: The source Y position.
    /// - parameter srcZ: The source Z position.
    /// - parameter width: The width of the region to blit.
    /// - parameter height: The height of the region to blit.
    /// - parameter depth: The depth of the region to blit.
    ///
    /// - remark: The destination texture must be created with the `TextureOptions.BlitDestination` flag
    ///
    public func blit(viewId: UInt8, dest: Texture, destMip: UInt8, destX: UInt16, destY: UInt16, destZ: UInt16,
                     attachment: UInt8, srcMip: UInt8, srcX: UInt16, srcY: UInt16, srcZ: UInt16,
                     width: UInt16, height: UInt16, depth: UInt16) {
        
        bgfx_blit_frame_buffer(viewId, dest.handle, destMip, destX, destY, destZ, handle, attachment, srcMip, srcX, srcY, srcZ, width, height, depth)
    }
    
    /// Reads the contents of the framebuffer and stores them in memory pointed to by `data`
    ///
    /// - parameter attachment: The frame buffer attachment from which to read
    /// - parameter data: The destination for the read image data
    ///
    /// - returns: The frame number when the result will be available. See `bgfx.frame`
    ///
    /// - remark: The attachment must have been created with the `TextureOptions.ReadBack` flag
    ///
    public func read(attachment: UInt8, data: UnsafeMutableRawPointer) -> UInt32 {
        return bgfx_read_frame_buffer(handle, attachment, data)
    }
}
