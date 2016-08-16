// Copyright 2016 Stuart Carnie.
// License: https://github.com/stuartcarnie/SwiftBGFX#license-bsd-2-clause
//

public enum TextureType {
    case type2D
}

/// Represents a loaded texture
public final class Texture {
    let handle: bgfx_texture_handle_t
    let info: bgfx_texture_info_t
    
    /// The width of the texture
    public var width: UInt16 {
        return info.width
    }

    /// The height of the texture
    public var height: UInt16 {
        return info.height
    }

    /// The depth of the texture, if 3D
    public var depth: UInt16 {
        return info.depth
    }

    /// Indicates whether the texture is a cubemap
    public var isCubeMap: Bool {
        return info.cubeMap
    }

    /// The number of mip levels in the texture
    public var mipLevels: UInt8 {
        return info.numMips
    }

    /// The number of bits per pixel
    public var bitsPerPixel: UInt8 {
        return info.bitsPerPixel
    }

    /// The size of the entire texture, in bytes
    public var sizeInBytes: UInt32 {
        return info.storageSize
    }

    /// The format of the image data
    public var format: TextureFormat {
        return unsafeBitCast(info.format, to: TextureFormat.self)
    }

    init(handle: bgfx_texture_handle_t, info: bgfx_texture_info_t) {
        self.handle = handle
        self.info = info
    }

    /// Updates the data in a 2D texture
    ///
    /// - parameter mipLevel: The mip level to update
    /// - parameter x: The X coordinate of the rectangle to update
    /// - parameter y: The Y coordinate of the rectangle to update
    /// - parameter width: The width of the rectangle to update
    /// - parameter height: The height of the rectangle to update
    /// - parameter memory: The new image data
    /// - parameter pitch: The pitch of the image data
    ///
    public func update2D(mipLevel: UInt8, x: UInt16, y: UInt16, width: UInt16, height: UInt16, memory: MemoryBlock, pitch: UInt16) {
        bgfx_update_texture_2d(handle, mipLevel, x, y, width, height, memory.handle, pitch)
    }

    /// Copies the contents of a texture to another texture
    ///
    /// - parameter viewId: The view in which the blit will be ordered.
    /// - parameter dest: The destination texture.
    /// - parameter destX: The destination X position.
    /// - parameter destY: The destination Y position.
    /// - parameter srcX: The source X position.
    /// - parameter srcY: The source Y position.
    /// - parameter width: The width of the region to blit.
    /// - parameter height: The height of the region to blit.
    ///
    /// - remark: The destination texture must be created with the `TextureFlags.BlitDestination` flag
    ///
    public func blit(viewId: UInt8, dest: Texture, destX: UInt16, destY: UInt16,
                     srcX: UInt16, srcY: UInt16,
                     width: UInt16, height: UInt16, depth: UInt16) {

        blit(viewId: viewId, dest: dest, destMip: 0, destX: destX, destY: destY, destZ: 0, srcMip: 0, srcX: srcX, srcY: srcY, srcZ: 0, width: width, height: height, depth: 0)
    }

    /// Copies the contents of a texture to another texture
    ///
    /// - parameter viewId: The view in which the blit will be ordered.
    /// - parameter dest: The destination texture.
    /// - parameter destMip: The destination mip level.
    /// - parameter destX: The destination X position.
    /// - parameter destY: The destination Y position.
    /// - parameter destZ: The destination Z position.
    /// - parameter srcMip: The source mip level.
    /// - parameter srcX: The source X position.
    /// - parameter srcY: The source Y position.
    /// - parameter srcZ: The source Z position.
    /// - parameter width: The width of the region to blit.
    /// - parameter height: The height of the region to blit.
    /// - parameter depth: The depth of the region to blit.
    ///
    /// - remark: The destination texture must be created with the `TextureFlags.BlitDestination` flag
    ///
    public func blit(viewId: UInt8, dest: Texture, destMip: UInt8, destX: UInt16, destY: UInt16, destZ: UInt16,
                     srcMip: UInt8, srcX: UInt16, srcY: UInt16, srcZ: UInt16,
                     width: UInt16, height: UInt16, depth: UInt16) {

        bgfx_blit(viewId, dest.handle, destMip, destX, destY, destZ, handle, srcMip, srcX, srcY, srcZ, width, height, depth)
    }

    /// Reads the contents of the texture and stores them in memory pointed to by `data`
    ///
    /// - parameter data: The destination for the read image data
    ///
    /// - returns: The frame number when the result will be available. See `bgfx.frame`
    ///
    /// - remark: The texture must have been created with the `TextureFlags.ReadBack` flag
    ///
    public func read(data: UnsafeMutableRawPointer) -> UInt32 {
        return bgfx_read_texture(handle, data)
    }
}
