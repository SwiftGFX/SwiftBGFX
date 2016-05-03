//
//  texture.swift
//  bgfx Test
//
//  Created by Stuart Carnie on 4/21/16.
//  Copyright © 2016 SGC. All rights reserved.
//

public enum TextureType {
    case Type2D
}

public struct TextureDescriptor {
    
}

public final class Texture {
    typealias TextureHandle = bgfx_texture_handle_t
    typealias TextureInfo = bgfx_texture_info_t
    
    let handle: TextureHandle
    let info: TextureInfo
    
    init(handle: TextureHandle, info: TextureInfo) {
        self.handle = handle
        self.info = info
    }
    
    /// The width of the texture
    public var Width: UInt16 {
        return info.width
    }
    
    /// The height of the texture
    public var Height: UInt16 {
        return info.height
    }
    
    // MARK: make functions
    
    /// Creates a new 2D texture
    public static func make2D(width: UInt16, height: UInt16, mipCount: UInt8, format: TextureFormat, flags: TextureFlags = [.None], memory: MemoryBlock? = nil) -> Texture {
        var info = TextureInfo()
        bgfx_calc_texture_size(&info, width, height, 1, false, mipCount, bgfx_texture_format_t(format.rawValue))
        let handle = bgfx_create_texture_2d(info.width, info.height, info.numMips, bgfx_texture_format_t(format.rawValue), flags.rawValue, memory?.handle ?? nil)
        
        return Texture(handle: handle, info: info)
    }
}