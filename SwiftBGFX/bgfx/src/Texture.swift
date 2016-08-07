// Copyright 2016 Stuart Carnie.
// License: https://github.com/stuartcarnie/SwiftBGFX#license-bsd-2-clause
//

public enum TextureType {
    case type2D
}

public final class Texture {
    typealias TextureHandle = bgfx_texture_handle_t
    typealias TextureInfo = bgfx_texture_info_t
    
    let handle: TextureHandle
    let info: TextureInfo
    
    /// The width of the texture
    public var Width: UInt16 {
        return info.width
    }
    
    /// The height of the texture
    public var Height: UInt16 {
        return info.height
    }
    
    /// The depth of the texture, if 3D
    public var Depth: UInt16 {
        return info.depth
    }
    
    /// Indicates whether the texture is a cubemap
    public var IsCubeMap: Bool {
        return info.cubeMap
    }
    
    /// The number of mip levels in the texture
    public var MipLevels: UInt8 {
        return info.numMips
    }
    
    /// The number of bits per pixel
    public var BitsPerPixel: UInt8 {
        return info.bitsPerPixel
    }
    
    /// The size of the entire texture, in bytes
    public var SizeInBytes: UInt32 {
        return info.storageSize
    }
    
    /// The format of the image data
    public var Format: TextureFormat {
        return unsafeBitCast(info.format, to: TextureFormat.self)
    }
    
    init(handle: TextureHandle, info: TextureInfo) {
        self.handle = handle
        self.info = info
    }
    
    /// Updates the data in a 2D texture
    ///
    /// - parameters:
    ///
    ///     - mipLevel: The mip level to update
    ///     - x: The X coordinate of the rectangle to update
    ///     - y: The Y coordinate of the rectangle to update
    ///     - width: The width of the rectangle to update
    ///     - height: The height of the rectangle to update
    ///     - memory: The new image data
    ///     - pitch: The pitch of the image data
    ///
    public func update2D(_ mipLevel: UInt8, x: UInt16, y: UInt16, width: UInt16, height: UInt16, memory: MemoryBlock, pitch: UInt16) {
        bgfx_update_texture_2d(handle, mipLevel, x, y, width, height, memory.handle, pitch)
    }
    
    /// Blits the contents of the texture to another texture
    ///
    /// - parameters:
    ///
    ///     - viewId: The view in which the blit will be ordered.
    ///     - dest: The destination texture.
    ///     - destX: The destination X position.
    ///     - destY: The destination Y position.
    ///     - srcX: The source X position.
    ///     - srcY: The source Y position.
    ///     - width: The width of the region to blit.
    ///     - height: The height of the region to blit.
    ///
    /// - remark: The destination texture must be created with the `TextureFlags.BlitDestination` flag
    ///
    public func blit(_ viewId: UInt8, dest: Texture, destX: UInt16, destY: UInt16,
                     srcX: UInt16, srcY: UInt16,
                     width: UInt16, height: UInt16, depth: UInt16) {
        
        blit(viewId, dest: dest, destMip: 0, destX: destX, destY: destY, destZ: 0, srcMip: 0, srcX: srcX, srcY: srcY, srcZ: 0, width: width, height: height, depth: 0)
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
    public func blit(_ viewId: UInt8, dest: Texture, destMip: UInt8, destX: UInt16, destY: UInt16, destZ: UInt16,
                     srcMip: UInt8, srcX: UInt16, srcY: UInt16, srcZ: UInt16,
                     width: UInt16, height: UInt16, depth: UInt16) {
        
        bgfx_blit(viewId, dest.handle, destMip, destX, destY, destZ, handle, srcMip, srcX, srcY, srcZ, width, height, depth)
    }
    
    /// Reads the contents of the texture and stores them in memory pointed to by `data`
    ///
    /// - parameters:
    ///
    ///     - data: The destination for the read image data
    ///
    /// - returns: The frame number when the result will be available. See `bgfx.frame`
    ///
    /// - remark: The texture must have been created with the `TextureFlags.ReadBack` flag
    ///
    public func read(_ data: UnsafeMutablePointer<Void>) -> UInt32 {
        return bgfx_read_texture(handle, data)
    }
}
