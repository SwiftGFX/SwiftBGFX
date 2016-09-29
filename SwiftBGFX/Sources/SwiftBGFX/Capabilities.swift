// Copyright 2016 Stuart Carnie.
// License: https://github.com/stuartcarnie/SwiftBGFX#license-bsd-2-clause
//

import Cbgfx

/// Contains information about the capabilities of the rendering device
public struct Capabilities {
    
    /// The currently active rendering backend API
    public let backend: RendererBackend
    
    /// A set of extended features supported by the device
    public let supported: CapsOptions
    
    public let vendorId: UInt16
    
    public let deviceId: UInt16
    
    /// Indicates whether depth coordinates in normalized device-coordinate range from -1 to 1 (true) or 0 to 1 (false)
    public let homogeneousDepth: Bool
    
    /// Indicates whether the coordinate system origin is at the bottom left or top left
    public let originBottomLeft: Bool
    
    public struct GPU {
        public var vendorId: UInt16 = 0
        public var deviceId: UInt16 = 0
        
        init() {}
        
        init(v: bgfx_caps_gpu_t) {
            vendorId = v.vendorId
            deviceId = v.deviceId
        }
    }
    
    public let gpus: [GPU]
    
    public let limits: Limits
    
    public let formats: [TextureFormatSupport]
    
    init(caps: UnsafePointer<bgfx_caps_t>) {
        var s = caps.pointee
        backend = RendererBackend(rawValue: s.rendererType.rawValue)!
        supported = CapsOptions(rawValue: s.supported)
        limits = Limits(s.limits)
        
        vendorId = s.vendorId
        deviceId = s.deviceId
        homogeneousDepth = s.homogeneousDepth
        originBottomLeft = s.originBottomLeft
        
        var gpus = [GPU](repeating: GPU(), count: Int(s.numGPUs))
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
        
        self.gpus = gpus
        
        var formats = [TextureFormatSupport](repeating: TextureFormatSupport.none, count: Int(BGFX_TEXTURE_FORMAT_COUNT.rawValue))
        memcpy(&formats, &s.formats.0, MemoryLayout<TextureFormatSupport>.size * Int(BGFX_TEXTURE_FORMAT_COUNT.rawValue))
        self.formats = formats
    }
    
    public struct Limits {
        
        /// Maximum number of draw calls per frame
        public let maxDrawCalls: Int
        
        /// Maximum number of blits per frame
        public let maxBlits: Int;
        public let maxTextureSize: Int;
        public let maxViews: Int;
        public let maxFrameBuffers: Int;
        public let maxFBAttachments: Int;
        public let maxPrograms: Int;
        public let maxShaders: Int;
        public let maxTextures: Int;
        public let maxTextureSamplers: Int;
        public let maxVertexDecls: Int;
        public let maxVertexStreams: Int;
        public let maxIndexBuffers: Int;
        public let maxVertexBuffers: Int;
        public let maxDynamicIndexBuffers: Int;
        public let maxDynamicVertexBuffers: Int;
        public let maxUniforms: Int;
        public let maxOcclusionQueries: Int;
        
        init(_ l: bgfx_caps_limits_t) {
            maxDrawCalls = Int(l.maxDrawCalls)
            maxBlits = Int(l.maxBlits)
            maxTextureSize = Int(l.maxTextureSize)
            maxViews = Int(l.maxViews)
            maxFrameBuffers = Int(l.maxFrameBuffers)
            maxFBAttachments = Int(l.maxFBAttachments)
            maxPrograms = Int(l.maxPrograms)
            maxShaders = Int(l.maxShaders)
            maxTextures = Int(l.maxTextures)
            maxTextureSamplers = Int(l.maxTextureSamplers)
            maxVertexDecls = Int(l.maxVertexDecls)
            maxVertexStreams = Int(l.maxVertexStreams)
            maxIndexBuffers = Int(l.maxIndexBuffers)
            maxVertexBuffers = Int(l.maxVertexBuffers)
            maxDynamicIndexBuffers = Int(l.maxDynamicIndexBuffers)
            maxDynamicVertexBuffers = Int(l.maxDynamicVertexBuffers)
            maxUniforms = Int(l.maxUniforms)
            maxOcclusionQueries = Int(l.maxOcclusionQueries)
        }
    }

}
