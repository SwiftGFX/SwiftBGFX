// Copyright 2016 Stuart Carnie.
// License: https://github.com/stuartcarnie/SwiftBGFX#license-bsd-2-clause
//

public extension Texture {
    
    /// Creates a new 2D texture
    ///
    /// - parameters:
    ///
    ///     - width: The width of the texture
    ///     - height: The height of the texture
    ///     - mipCount: The number of mip levels
    ///     - format: The format of the texture data
    ///     - flags: Flags that control texture behavior
    ///     - memory: Optional source for texture data
    ///
    /// - returns: The newly created texture handle
    ///
    public static func make2D(_ width: UInt16, height: UInt16, mipCount: UInt8, format: TextureFormat, flags: TextureFlags = [.none], memory: MemoryBlock? = nil) -> Texture {
        var info = TextureInfo()
        bgfx_calc_texture_size(&info, width, height, 1, false, mipCount, bgfx_texture_format_t(format.rawValue))
        let handle = bgfx_create_texture_2d(info.width, info.height, info.numMips, bgfx_texture_format_t(format.rawValue), flags.rawValue, memory?.handle ?? nil)
        
        return Texture(handle: handle, info: info)
    }
    
    /// Creates a new 2D texture that scales with backbuffer size
    ///
    /// - parameters:
    ///
    ///     - ratio: The amount to scale when the backbuffer resizes
    ///     - mipCount: The number of mip levels
    ///     - format: The format of the texture data
    ///     - flags: Flags that control texture behavior
    ///
    /// - returns: The newly created texture handle
    ///
    public static func make2D(_ ratio: BackbufferRatio, mipCount: UInt8, format: TextureFormat, flags: TextureFlags = [.none]) -> Texture {
        var info = TextureInfo()
        info.format = unsafeBitCast(format, to: bgfx_texture_format_t.self)
        info.numMips = mipCount
        
        let handle = bgfx_create_texture_2d_scaled(bgfx_backbuffer_ratio_t(ratio.rawValue), mipCount, bgfx_texture_format_t(format.rawValue), flags.rawValue)
        
        return Texture(handle: handle, info: info)
    }
    
    /// Creates a new texture from a file loaded in memory
    ///
    /// - parameters:
    ///
    ///     - memory: The content of the file
    ///     - flags: Flags that control texture behavior
    ///     - skipMips: A number of top level mips to skip when parsing texture data
    ///
    /// - returns: new texture
    ///
    /// - remark: This API supports textures in the following container formats:
    ///
    ///     - DDS
    ///     - KTX
    ///     - PVR
    ///
    public convenience init(memory: MemoryBlock, flags: TextureFlags = [.none], skipMips: UInt8 = 0) {
        var info = TextureInfo()
        let handle = bgfx_create_texture(memory.handle, unsafeBitCast(flags, to: UInt32.self), skipMips, &info)
        self.init(handle: handle, info: info)
    }
}
