//
//  capabilities.swift
//  bgfx Test
//
//  Created by Stuart Carnie on 4/21/16.
//  Copyright © 2016 SGC. All rights reserved.
//

/// Contains information about the capabilities of the rendering device
public struct Capabilities {
    
    /// The currently active rendering backend API
    public let backend: RendererBackend
    
    /// A set of extended features supported by the device
    public let supported: CapsOptions
    
    /// The maximum size of a texture, in pixels
    public let maxTextureSize: UInt16

    /// The maximum number of render views supported
    public let maxViews: UInt16

    /// The maximum number of draw calls in a single frame
    public let maxDrawCalls: UInt32
    
    /// The maximum number of attachments to a single framebuffer
    public let maxFBAttachments: UInt8
        
    public let vendorId: UInt16
    
    public let deviceId: UInt16
    
    /// Indicates whether depth coordinates in normalized device-coordinate range from -1 to 1 (true) or 0 to 1 (false)
    public let homogeneousDepth: Bool
    
    /// Indicates whether the coordinate system origin is at the bottom left or top left
    public let originBottomLeft: Bool
    
    public class GPU {
        public var vendorId: UInt16 = 0
        public var deviceId: UInt16 = 0
        
        init() {}
        
        init(v: bgfx_caps_gpu_t) {
            vendorId = v.vendorId
            deviceId = v.deviceId
        }
    }
    
    public let GPUs: [GPU]
    
    public let formats: [TextureFormatSupport]
    
    init(caps: UnsafePointer<bgfx_caps_t>) {
        var s = caps.memory
        backend = RendererBackend(rawValue: s.rendererType.rawValue)!
        supported = CapsOptions(rawValue: s.supported)
        maxDrawCalls = s.maxDrawCalls
        maxTextureSize = s.maxTextureSize
        maxViews = s.maxViews
        maxFBAttachments = s.maxFBAttachments
        vendorId = s.vendorId
        deviceId = s.deviceId
        homogeneousDepth = s.homogeneousDepth
        originBottomLeft = s.originBottomLeft
        
        var gpus = [GPU](count: Int(s.numGPUs), repeatedValue: GPU())
        switch s.numGPUs {
        case 4:
            gpus[3] = GPU(v:s.gpu.3)
            fallthrough
            
        case 3:
            gpus[2] = GPU(v:s.gpu.2)
            fallthrough
            
        case 2:
            gpus[1] = GPU(v:s.gpu.1)
            fallthrough
            
        case 1:
            gpus[0] = GPU(v:s.gpu.0)
            
        default:
            break
        }
        
        GPUs = gpus
        
        var formats = [TextureFormatSupport](count: Int(BGFX_TEXTURE_FORMAT_COUNT.rawValue), repeatedValue: TextureFormatSupport.None)
        memcpy(&formats, &s.formats.0, sizeof(TextureFormatSupport) * Int(BGFX_TEXTURE_FORMAT_COUNT.rawValue))
        self.formats = formats
    }
}