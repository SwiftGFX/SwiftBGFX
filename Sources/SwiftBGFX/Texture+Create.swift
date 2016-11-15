// Copyright 2016 Stuart Carnie.
// License: https://github.com/stuartcarnie/SwiftBGFX#license-bsd-2-clause
//

import Cbgfx

public extension Texture {
    
    /// Creates a new 2D texture
    ///
    /// - parameter parameter width: The width of the texture
    /// - parameter height: The height of the texture
    /// - parameter mipCount: The number of mip levels
    /// - parameter format: The format of the texture data
    /// - parameter options: Options that control texture behavior
    /// - parameter memory: Optional source for texture data
    ///
    /// - returns: The newly created texture handle
    ///
    public static func make2D(width: UInt16, height: UInt16, mipCount: UInt16, format: TextureFormat, options: TextureOptions = [.none], memory: MemoryBlock? = nil) -> Texture {
        var info = bgfx_texture_info_t()
        bgfx_calc_texture_size(&info, width, height, 1, false, false, mipCount, bgfx_texture_format_t(format.rawValue))
        let handle = bgfx_create_texture_2d(info.width, info.height, false, UInt16(info.numMips), bgfx_texture_format_t(format.rawValue), options.rawValue, memory?.handle ?? nil)

        return Texture(handle: handle, info: TextureInfo.make(from: info))
    }

    /// Creates a new 2D texture that scales with the back buffer
    ///
    /// - parameter ratio: The amount to scale when the backbuffer resizes
    /// - parameter mipCount: The number of mip levels
    /// - parameter format: The format of the texture data
    /// - parameter options: Options that control texture behavior
    ///
    /// - returns: The newly created texture handle
    ///
    public static func make2D(ratio: BackbufferRatio, mipCount: UInt16, format: TextureFormat, options: TextureOptions = [.none]) -> Texture {
        var info = bgfx_texture_info_t()
        info.format = unsafeBitCast(format, to: bgfx_texture_format_t.self)
        info.numMips = UInt8(mipCount)

        let handle = bgfx_create_texture_2d_scaled(bgfx_backbuffer_ratio_t(ratio.rawValue), false, mipCount, bgfx_texture_format_t(format.rawValue), options.rawValue)

        return Texture(handle: handle, info: TextureInfo.make(from: info))
    }

    /// Creates a new texture from a file loaded in memory
    ///
    /// - parameter memory: The content of the file
    /// - parameter options: Options that control texture behavior
    /// - parameter skipMips: A number of top level mips to skip when parsing texture data
    ///
    /// - returns: new texture
    ///
    /// - remark: This API supports textures in the following container formats:
    ///
    ///     - DDS
    ///     - KTX
    ///     - PVR
    ///
    public convenience init(memory: MemoryBlock, options: TextureOptions = [.none], skipMips: UInt8 = 0) {
        var info = bgfx_texture_info_t()
        let handle = bgfx_create_texture(memory.handle, unsafeBitCast(options, to: UInt32.self), skipMips, &info)
        self.init(handle: handle, info: TextureInfo.make(from: info))
    }
}
