// Copyright 2016 Stuart Carnie.
// License: https://github.com/stuartcarnie/SwiftBGFX#license-bsd-2-clause
//

import Cbgfx

public enum TextureType {
    case type2D
}

/// Represents a loaded texture
public final class Texture {
    let handle: bgfx_texture_handle_t
	
	public let info: TextureInfo

    init(handle: bgfx_texture_handle_t, info: TextureInfo) {
        self.handle = handle
        self.info = info
    }

    /// Updates the data in a 2D texture
    ///
    /// - parameter layer: The layer to update
    /// - parameter mipLevel: The mip level to update
    /// - parameter x: The X coordinate of the rectangle to update
    /// - parameter y: The Y coordinate of the rectangle to update
    /// - parameter width: The width of the rectangle to update
    /// - parameter height: The height of the rectangle to update
    /// - parameter memory: The new image data
    /// - parameter pitch: The pitch of the image data
    ///
    public func update2D(mipLevel: UInt8, layer: UInt16, x: UInt16, y: UInt16, width: UInt16, height: UInt16, memory: MemoryBlock, pitch: UInt16) {
        bgfx_update_texture_2d(handle, layer, mipLevel, x, y, width, height, memory.handle, pitch)
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
        bgfx_update_texture_2d(handle, 0, mipLevel, x, y, width, height, memory.handle, pitch)
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
    /// - remark: The destination texture must be created with the `TextureOptions.BlitDestination` flag
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
    /// - remark: The destination texture must be created with the `TextureOptions.BlitDestination` flag
    ///
    public func blit(viewId: UInt8, dest: Texture, destMip: UInt8, destX: UInt16, destY: UInt16, destZ: UInt16,
                     srcMip: UInt8, srcX: UInt16, srcY: UInt16, srcZ: UInt16,
                     width: UInt16, height: UInt16, depth: UInt16) {

        bgfx_blit(viewId, dest.handle, destMip, destX, destY, destZ, handle, srcMip, srcX, srcY, srcZ, width, height, depth)
    }

    /// Reads the contents of the texture and stores them in memory pointed to by `data`
    ///
    /// - parameter data: The destination for the read image data
    /// - parameter mip: The mip level to read the image data from
    ///
    /// - returns: The frame number when the result will be available. See `bgfx.frame`
    ///
    /// - remark: The texture must have been created with the `TextureOptions.ReadBack` flag
    ///
    public func read(data: UnsafeMutableRawPointer, mip: UInt8) -> UInt32 {
        return bgfx_read_texture(handle, data, mip)
    }
}
