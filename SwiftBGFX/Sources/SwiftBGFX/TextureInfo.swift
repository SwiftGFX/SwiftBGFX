// Copyright 2016 Stuart Carnie.
// License: https://github.com/stuartcarnie/SwiftBGFX#license-bsd-2-clause
//

import Cbgfx

public struct TextureInfo {
    /// The format of the image data
    public let format: TextureFormat
    
    /// The size of the entire texture, in bytes
    public let sizeInBytes: UInt32
    
    /// The width of the texture
    public let width: UInt16
    
    /// The height of the texture
    public let height: UInt16
    
    /// The depth of the texture, if 3D
    public let depth: UInt16
    
    /// The number of layers in the texture
    public let layers: UInt16
    
    /// The number of mip levels in the texture
    public let mipLevels: UInt8
    
    /// The number of bits per pixel
    public let bitsPerPixel: UInt8
    
    /// Indicates whether the texture is a cubemap
    public let isCubeMap: Bool
    
    internal static func make(from: bgfx_texture_info_t) -> TextureInfo {
        return TextureInfo(format: TextureFormat.make(from: from.format),
                           sizeInBytes: from.storageSize,
                           width: from.width, height: from.height,
                           depth: from.depth, layers: from.numLayers,
                           mipLevels: from.numMips,
                           bitsPerPixel: from.bitsPerPixel,
                           isCubeMap: from.cubeMap)
    }
}
