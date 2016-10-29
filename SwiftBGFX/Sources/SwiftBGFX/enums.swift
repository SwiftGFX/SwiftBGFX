// Copyright 2016 Stuart Carnie.
// License: https://github.com/stuartcarnie/SwiftBGFX#license-bsd-2-clause
//

import Cbgfx

/// Specifies the supported rendering backend APIs.
public enum RendererBackend: UInt32 {
    /// No backend given.
 	case none = 0
    
    /// Direct3D 9
 	case direct3D9
    
    /// Direct3D 11
 	case direct3D11
    
    /// Direct3D 12
    case direct3D12
    
    /// GNM
    case gnm
    
    /// Apple Metal.
 	case metal
    
    /// OpenGL ES
 	case openGLES
    
    /// OpenGL
 	case openGL
    
    /// Vulkan
 	case vulkan
    
    /// Used during initialization to indicate the library should
    /// pick the best renderer for the running hardware and OS.
 	case best
}

/// Specifies vertex attribute usages
public enum VertexAttributeUsage: UInt32 {
    /// Position data.
	case position = 0
    
    /// Normals.
	case normal
    
    /// Tangents.
	case tangent
    
    /// Bitangents.
	case bitangent
    
    /// First color channel.
	case color0
    
    /// Second color channel.
	case color1
    
    /// Indices.
	case indices
    
    /// Animation weights.
	case weight
    
    /// First texture coordinate channel (arbitrary data).
	case texCoord0
    
    /// Second texture coordinate channel (arbitrary data).
	case texCoord1
    
    /// Third texture coordinate channel (arbitrary data).
	case texCoord2
    
    /// Fourth texture coordinate channel (arbitrary data).
	case texCoord3
    
    /// Fifth texture coordinate channel (arbitrary data).
	case texCoord4
    
    /// Sixth texture coordinate channel (arbitrary data).
	case texCoord5
    
    /// Seventh texture coordinate channel (arbitrary data).
	case texCoord6
    
    /// Eighth texture coordinate channel (arbitrary data).
	case texCoord7
}

/// Specifies data types for vertex attributes
public enum VertexAttribType: UInt32 {
    
    /// One-byte unsigned integer
    case uint8 = 0
    
    /// 10-bit unsigned integer
    /// - remark: Availability depends on Caps flags
    case uint10
    
    /// Two-byte signed integer
    case int16
    
    /// Two-byte float
    /// - remark: Availability depends on Caps flags
    case half
    
    /// Four-byte float
    case float
}


/// Specifies the format of a texture's data.
///
/// - remark:
/// Check Caps flags for hardware format support.
public enum TextureFormat: UInt32 {
    /// Block compression with three color channels, 1 bit alpha.
	case bc1 = 0
    
    /// Block compression with three color channels, 4 bits alpha.
	case bc2
    
    /// Block compression with three color channels, 8 bits alpha.
	case bc3
    
    /// Block compression for 1-channel color.
	case bc4
    
    /// Block compression for 2-channel color.
	case bc5
    
    /// Block compression for three-channel HDR color.
	case bc6H
    
    /// Highest quality block compression.
	case bc7
    
    /// Original ETC block compression.
	case etc1
    
    /// Improved ETC block compression (no alpha).
	case etc2
    
    /// Improved ETC block compression with full alpha.
	case etc2A
    
    /// Improved ETC block compression with 1-bit punchthrough alpha.
	case etc2A1
    
    /// PVRTC1 compression (2 bits per pixel)
	case ptc12
    
    /// PVRTC1 compression (4 bits per pixel)
	case ptc14
    
    /// PVRTC1 compression with alpha (2 bits per pixel)
	case ptc12A
    
    /// PVRTC1 compression with alpha (4 bits per pixel)
	case ptc14A
    
    /// PVRTC2 compression with alpha (2 bits per pixel)
	case ptc22
    
    /// PVRTC2 compression with alpha (4 bits per pixel)
	case ptc24
    
    /// Unknown texture format.
	case unknown
    
    /// 1-bit single channel.
	case r1
    
    /// 8-bit single channel (alpha).
	case a8
    
    /// 8-bit single channel.
	case r8
    
    /// 8-bit single channel (integer).
	case r8i
    
    /// 8-bit single channel (unsigned).
	case r8u
    
    /// 8-bit single channel (signed).
	case r8s
    
    /// 16-bit single channel.
	case r16
    
    /// 16-bit single channel (integer).
	case r16I
    
    /// 16-bit single channel (unsigned).
	case r16U
    
    /// 16-bit single channel (float).
	case r16F
    
    /// 16-bit single channel (signed).
	case r16S
    
    /// 32-bit single channel (integer).
	case r32I
    
    /// 32-bit single channel (unsigned).
	case r32U
    
    /// 32-bit single channel (float).
	case r32F
    
    /// 8-bit two channel.
	case rg8
    
    /// 8-bit two channel (integer).
	case rg8I
    
    /// 8-bit two channel (unsigned).
	case rg8U
    
    /// 8-bit two channel (signed).
	case rg8S
    
    /// 16-bit two channel.
	case rg16
    
    /// 16-bit two channel (integer).
	case rg16I
    
    /// 16-bit two channel (unsigned).
	case rg16U
    
    /// 16-bit two channel (float).
	case rg16F
    
    /// 16-bit two channel (signed).
	case rg16S
    
    /// 32-bit two channel (integer).
	case rg32I
    
    /// 32-bit two channel (unsigned).
	case rg32U
    
    /// 32-bit two channel (float).
	case rg32F
    
    /// 8-bit three channel.
	case rgb8
    
    /// 8-bit three channel (integer).
	case rgb8I
    
    /// 8-bit three channel (unsigned).
	case rgb8U
    
    /// 8-bit three channel (signed).
	case rgb8S
    
    /// 9-bit three channel floating point with shared 5-bit exponent.
	case rgb9E5F
    
    /// 8-bit BGRA color.
	case bgra8
    
    /// 8-bit RGBA color.
	case rgba8
    
    /// 8-bit RGBA color (integer).
	case rgba8I
    
    /// 8-bit RGBA color (unsigned).
	case rgba8U
    
    /// 8-bit RGBA color (signed).
	case rgba8S
    
    /// 16-bit RGBA color.
	case rgba16
    
    /// 16-bit RGBA color (integer).
	case rgba16I
    
    /// 16-bit RGBA color (unsigned).
	case rgba16U
    
    /// 16-bit RGBA color (float).
	case rgba16F
    
    /// 16-bit RGBA color (signed).
	case rgba16S
    
    /// 32-bit RGBA color (integer).
	case rgba32I
    
    /// 32-bit RGBA color (unsigned).
	case rgba32U
    
    /// 32-bit RGBA color (float).
	case rgba32F
    
    /// 5-6-6 color.
	case r5g6B5
    
    /// 4-bit RGBA color.
	case rgba4
    
    /// 5-bit RGB color with 1-bit alpha.
	case rgb5A1
    
    /// 10-bit RGB color with 2-bit alpha.
	case rgb10A2
    
    /// 11-11-10 color (float).
	case r11G11B10F
    
    /// Unknown depth format.
	case unknownDepth
    
    /// 16-bit depth.
	case d16
    
    /// 24-bit depth.
	case d24
    
    /// 24-bit depth, 8-bit stencil.
	case d24S8
    
    /// 32-bit depth.
	case d32
    
    /// 16-bit depth (float).
	case d16F
    
    /// 24-bit depth (float).
	case d24F
    
    /// 32-bit depth (float).
	case d32F
    
    /// 8-bit stencil.
	case d0s8
    
    internal static func make(from bgfxType: bgfx_texture_format) -> TextureFormat {
        return TextureFormat(rawValue: bgfxType.rawValue)!
    }
}

/// Specifies the type of uniform data.
public enum UniformType : UInt32 {
    
    /// Single integer.
    case int1
    
    /// 4D vector.
    case vector4 = 2
    
    /// 3x3 matrix.
    case matrix3x3
    
    /// 4x4 matrix.
    case matrix4x4
}

/// Specifies various settings to change during a reset call
public struct ResetOptions: OptionSet {
    public let rawValue: UInt32
    
    public init(rawValue: UInt32) { self.rawValue = rawValue }
    
    /// No reset flags
    public static let none = ResetOptions(rawValue: 0x0000_0000)
    
    /// Not supported yet
    public static let fullScreen = ResetOptions(rawValue: 0x0000_0001)
    
    /// Enable 2x MSAA
    public static let msaax2 = ResetOptions(rawValue: 0x0000_0010)
    
    /// Enable 4x MSAA
    public static let msaax4 = ResetOptions(rawValue: 0x0000_0020)
    
    /// Enable 8x MSAA
    public static let msaax8 = ResetOptions(rawValue: 0x0000_0030)
    
    /// Enable 16x MSAA
    public static let msaax16 = ResetOptions(rawValue: 0x0000_0040)
    
    /// Enable V-Sync
    public static let vsync = ResetOptions(rawValue: 0x0000_0080)
    
    /// Turn on/off max anisotropy
    public static let maxAnisotropy = ResetOptions(rawValue: 0x0000_0100)
    
    /// Begin screen capture
    public static let capture = ResetOptions(rawValue: 0x0000_0200)
    
    /// HMD stereo rendering
    public static let hmd = ResetOptions(rawValue: 0x0000_0400)
    
    /// HMD stereo rendering debug mode
    public static let hmdDebug = ResetOptions(rawValue: 0x0000_0800)
    
    /// HMD calibration
    public static let hmdRecenter = ResetOptions(rawValue: 0x0000_1000)
    
    /// Flush rendering after submitting to GPU
    public static let flushAfterRender = ResetOptions(rawValue: 0x0000_2000)
    
    /// This flag specifies where flip occurs. Default behavior is that flip occurs
    /// before rendering new frame. This flag only has effect when `BGFX_CONFIG_MULTITHREADED=0`
    public static let flipAfterRender = ResetOptions(rawValue: 0x0000_4000)
    
    /// Enable sRGB backbuffer
    public static let sRGBBackBuffer = ResetOptions(rawValue: 0x0000_8000)
    
    /// Enable HiDPI rendering
    public static let hiDPI = ResetOptions(rawValue: 0x0001_0000)
    
    /// Enable depth clamp
    public static let depthClamp = ResetOptions(rawValue: 0x0002_0000)
    
    /// Suspend rendering
    public static let suspend = ResetOptions(rawValue: 0x0004_0000)
}

/// Specifies flags for clearing surfaces.
public struct ClearOptions: OptionSet {
    public let rawValue: UInt16
    public init(rawValue: UInt16) { self.rawValue = rawValue }
    
    /// No clear flags
    public static let none = ClearOptions(rawValue: 0x0000)
    
    /// Clear color
    public static let color = ClearOptions(rawValue: 0x0001)
    
    /// Clear depth
    public static let depth = ClearOptions(rawValue: 0x0002)
    
    /// Clear stencil
    public static let stencil = ClearOptions(rawValue: 0x0004)
    
    /// Discard frame buffer attachment 0
    public static let discardColor0 = ClearOptions(rawValue: 0x0008)
    
    /// Discard frame buffer attachment 1
    public static let discardColor1 = ClearOptions(rawValue: 0x0010)
    
    /// Discard frame buffer attachment 2
    public static let discardColor2 = ClearOptions(rawValue: 0x0020)
    
    /// Discard frame buffer attachment 3
    public static let discardColor3 = ClearOptions(rawValue: 0x0040)
    
    /// Discard frame buffer attachment 4
    public static let discardColor4 = ClearOptions(rawValue: 0x0080)
    
    /// Discard frame buffer attachment 5
    public static let discardColor5 = ClearOptions(rawValue: 0x0100)
    
    /// Discard frame buffer attachment 6
    public static let discardColor6 = ClearOptions(rawValue: 0x0200)
    
    /// Discard frame buffer attachment 7
    public static let discardColor7 = ClearOptions(rawValue: 0x0400)
    
    /// Discard frame buffer depth attachment
    public static let discardDepth = ClearOptions(rawValue: 0x0800)
    
    /// Discard frame buffer stencil attachment
    public static let discardStencil = ClearOptions(rawValue: 0x1000)
}

/// Specifies various capabilities supported by the rendering device
public struct CapsOptions: OptionSet {
    public let rawValue: UInt64

    public init(rawValue: UInt64) { self.rawValue = rawValue }
    
    /// Device supports alpha to coverage
    public static let alphaToCoverage = CapsOptions(rawValue: 0x0000_0000_0000_0001)
    
    /// Device supports independent blending of simultaneous render targets
    public static let blendIndependent = CapsOptions(rawValue: 0x0000_0000_0000_0002)
    
    /// Device supports compute shaders
    public static let compute = CapsOptions(rawValue: 0x0000_0000_0000_0004)

    /// Device supports conservative rasterization
    public static let conservativeRaster = CapsOptions(rawValue: 0x0000_0000_0000_0008)

    /// Device supports indirect drawing via GPU buffers
    public static let drawIndirect = CapsOptions(rawValue: 0x0000_0000_0000_0010)

    /// Fragment shaders can access depth values
    public static let fragmentDepth = CapsOptions(rawValue: 0x0000_0000_0000_0020)
    
    /// Device supports ordering of fragment output
    public static let fragmentOrdering = CapsOptions(rawValue: 0x0000_0000_0000_0040)

    /// Graphics debugger support is available
    public static let graphicsDebugger = CapsOptions(rawValue: 0x0000_0000_0000_0080)

    /// Device supports high-DPI rendering
    public static let hiDPI = CapsOptions(rawValue: 0x0000_0000_0000_0100)

    /// Head mounted displays are supported
    public static let headMountedDisplay = CapsOptions(rawValue: 0x0000_0000_0000_0200)

    /// Device supports 32-bit indices
    public static let index32 = CapsOptions(rawValue: 0x0000_0000_0000_0400)

    /// Device supports instancing
    public static let instancing = CapsOptions(rawValue: 0x0000_0000_0000_0800)

    /// Device supports occlusion queries
    public static let occlusionQuery = CapsOptions(rawValue: 0x0000_0000_0000_1000)

    /// Device supports multithreaded rendering
    public static let rendererMultithreaded = CapsOptions(rawValue: 0x0000_0000_0000_2000)

    /// Indicates whether the device can render to multiple swap chains
    public static let swapChain = CapsOptions(rawValue: 0x0000_0000_0000_4000)

    /// Device supports 2d texture arrays
    public static let texture2dArray = CapsOptions(rawValue: 0x0000_0000_0000_8000)
    
    /// Device supports 3D textures
    public static let texture3D = CapsOptions(rawValue: 0x0000_0000_0001_0000)

    /// Device supports texture blits
    public static let textureBlit = CapsOptions(rawValue: 0x0000_0000_0002_0000)

    /// Device supports all texture comparison modes
    public static let textureCompareAll = CapsOptions(rawValue: 0x0000_0000_000C_0000)

    /// Device supports "Less than or equal to" texture comparison mode
    public static let textureCompareLessOrEqual = CapsOptions(rawValue: 0x0000_0000_0008_0000)

    /// Device supports cubemap texture arrays
    public static let texture3dArray = CapsOptions(rawValue: 0x0000_0000_0010_0000)

    /// Device supports reading back texture data
    public static let textureReadBack = CapsOptions(rawValue: 0x0000_0000_0020_0000)

    /// Device supports 16-bit floats as vertex attributes
    public static let vertexAttributeHalf = CapsOptions(rawValue: 0x0000_0000_0040_0000)

    /// UInt10 vertex attributes are supported
    public static let vertexAttribUInt10 = CapsOptions(rawValue: 0x0000_0000_0080_0000)
}

/// Indicates the level of support for a specific texture format
public struct TextureFormatSupport: OptionSet {
    public let rawValue: UInt16

    public init(rawValue: UInt16) { self.rawValue = rawValue }

    /// The format is unsupported
    public static let none = TextureFormatSupport(rawValue: 0x0000)

    /// The format is supported for 2D color data and operations
    public static let texture2D = TextureFormatSupport(rawValue: 0x0001)

    /// The format is supported for 2D sRGB operations
    public static let texture2DsRGB = TextureFormatSupport(rawValue: 0x0002)

    /// The format is supported for 2D textures through library emulation
    public static let texture2DEmulated = TextureFormatSupport(rawValue: 0x0004)

    /// The format is supported for 3D color data and operations
    public static let texture3D = TextureFormatSupport(rawValue: 0x0008)

    /// The format is supported for 3D sRGB operations
    public static let texture3DsRGB = TextureFormatSupport(rawValue: 0x0010)

    /// The format is supported for 3D textures through library emulation
    public static let texture3DEmulated = TextureFormatSupport(rawValue: 0x0020)

    /// The format is supported for cube color data and operations
    public static let cube = TextureFormatSupport(rawValue: 0x0040)

    /// The format is supported for cube sRGB operations
    public static let cubesRGB = TextureFormatSupport(rawValue: 0x0080)

    /// The format is supported for cube textures through library emulation
    public static let cubeEmulated = TextureFormatSupport(rawValue: 0x0100)

    /// The format is supported for vertex texturing
    public static let vertex = TextureFormatSupport(rawValue: 0x0200)

    /// The format is supported for compute image operations
    public static let image = TextureFormatSupport(rawValue: 0x0400)

    /// The format is supported for framebuffers
    public static let frameBuffer = TextureFormatSupport(rawValue: 0x0800)

    /// The format is supported for MSAA framebuffers
    public static let frameBufferMSAA = TextureFormatSupport(rawValue: 0x1000)

    /// The format is supported for MSAA sampling
    public static let msaa = TextureFormatSupport(rawValue: 0x2000)
}

/// Specifies various texture options.
public struct TextureOptions : OptionSet {
    public let rawValue: UInt32
    public init(rawValue: UInt32) { self.rawValue = rawValue }
    
    /// No flags set.
    public static let none = TextureOptions(rawValue: 0x00000000)
    
    /// Mirror the texture in the U coordinate.
    public static let mirrorU = TextureOptions(rawValue: 0x00000001)
    
    /// Clamp the texture in the U coordinate.
    public static let clampU = TextureOptions(rawValue: 0x00000002)
    
    /// Use a border color for addresses outside the range in the U coordinate.
    public static let borderU = TextureOptions(rawValue: 0x00000003)
    
    /// Mirror the texture in the V coordinate.
    public static let mirrorV = TextureOptions(rawValue: 0x00000004)
    
    /// Clamp the texture in the V coordinate.
    public static let clampV = TextureOptions(rawValue: 0x00000008)
    
    /// Use a border color for addresses outside the range in the V coordinate.
    public static let borderV = TextureOptions(rawValue: 0x0000000c)
    
    /// Mirror the texture in the W coordinate.
    public static let mirrorW = TextureOptions(rawValue: 0x00000010)
    
    /// Clamp the texture in the W coordinate.
    public static let clampW = TextureOptions(rawValue: 0x00000020)
    
    /// Use a border color for addresses outside the range in the W coordinate.
    public static let borderW = TextureOptions(rawValue: 0x00000030)
    
    /// Use point filtering for texture minification.
    public static let minFilterPoint = TextureOptions(rawValue: 0x00000040)
    
    /// Use anisotropic filtering for texture minification.
    public static let minFilterAnisotropic = TextureOptions(rawValue: 0x00000080)
    
    /// Use point filtering for texture magnification.
    public static let magFilterPoint = TextureOptions(rawValue: 0x00000100)
    
    /// Use anisotropic filtering for texture magnification.
    public static let magFilterAnisotropic = TextureOptions(rawValue: 0x00000200)
    
    /// Use point filtering for texture mipmaps.
    public static let mipFilterPoint = TextureOptions(rawValue: 0x00000400)
    
    /// The texture will be used as a render target.
    public static let renderTarget = TextureOptions(rawValue: 0x00001000)
    
    /// The render target texture support 2x multisampling.
    public static let renderTargetMultisample2x = TextureOptions(rawValue: 0x00002000)
    
    /// The render target texture support 4x multisampling.
    public static let renderTargetMultisample4x = TextureOptions(rawValue: 0x00003000)
    
    /// The render target texture support 8x multisampling.
    public static let renderTargetMultisample8x = TextureOptions(rawValue: 0x00004000)
    
    /// The render target texture support 16x multisampling.
    public static let renderTargetMultisample16x = TextureOptions(rawValue: 0x00005000)
    
    /// The texture is only writeable (render target).
    public static let renderTargetWriteOnly = TextureOptions(rawValue: 0x00008000)
    
    /// Use a "less than" operator when comparing textures.
    public static let compareLess = TextureOptions(rawValue: 0x00010000)
    
    /// Use a "less than or equal" operator when comparing textures.
    public static let compareLessEqual = TextureOptions(rawValue: 0x00020000)
    
    /// Use an equality operator when comparing textures.
    public static let compareEqual = TextureOptions(rawValue: 0x00030000)
    
    /// Use a "greater than or equal" operator when comparing textures.
    public static let compareGreaterEqual = TextureOptions(rawValue: 0x00040000)
    
    /// Use a "greater than" operator when comparing textures.
    public static let compareGreater = TextureOptions(rawValue: 0x00050000)
    
    /// Use an inequality operator when comparing textures.
    public static let compareNotEqual = TextureOptions(rawValue: 0x00060000)
    
    /// Never compare two textures as equal.
    public static let compareNever = TextureOptions(rawValue: 0x00070000)
    
    /// Always compare two textures as equal.
    public static let compareAlways = TextureOptions(rawValue: 0x00080000)
    
    /// Texture is the target of compute shader writes.
    public static let computeWrite = TextureOptions(rawValue: 0x00100000)
    
    /// Texture data is in non-linear sRGB format.
    public static let srgb = TextureOptions(rawValue: 0x00200000)
    
    /// Texture can be used as the destination of a blit operation.
    public static let blitDestination = TextureOptions(rawValue: 0x00400000)
    
    /// Texture data can be read back.
    public static let readBack = TextureOptions(rawValue: 0x00800000)

    /// Default flags
    public static let `default` = TextureOptions(rawValue: UInt32.max)
}

/// Describes access rights for a compute buffer.
public enum ComputeBufferAccess: UInt32 {
    /// The buffer can only be read.
    case read
    
    /// The buffer can only be written to.
    case write
    
    /// The buffer can be read and written.
    case readWrite
}

/// Addresses a particular face of a cube map.
public enum CubeMapFace : UInt8 {
    /// The right face.
    case right
    
    /// The left face.
    case left
    
    /// The top face.
    case top
    
    /// The bottom face.
    case bottom
    
    /// The front face.
    case front
    
    /// The back face.
    case back
}

/// Specifies known vendor IDs
public enum VendorID: UInt16 {
    /// Autoselect adapter
    case none = 0x0000
    
    /// Special flag to use platform's software rasterizer, if available
    case software = 0x0001
    
    /// AMD adapter
    case amd = 0x1002
    
    /// Intel adapter
    case intel = 0x8086
    
    /// nVIDIA adapter
    case nvidia = 0x10de
}


/// Specifies scaling relative to the size of the backbuffer
public enum BackbufferRatio: UInt32 {
    
    /// Surface is equal to the backbuffer size
    case equal = 0
    
    /// Surface is half the backbuffer size
    case half
    
    /// Surface is a quater of the backbuffer size
    case quarter
    
    /// Surface is an eighth of the backbuffer size
    case eigth
    
    /// Surface is a sixteenth of the backbuffer size
    case sixteenth
    
    /// Surface is double the backbuffer size
    case double
}

/// Specifies various flags that control vertex and index buffer behavior.
public struct BufferOptions : OptionSet {
    public let rawValue: UInt16
    public init(rawValue: UInt16) { self.rawValue = rawValue }
    
    /// No flags specified.
    public static let none = BufferOptions(rawValue: 0x00)
    
    /// Specifies the format of data in a compute buffer as being 8x1.
    public static let computeFormat8x1 = BufferOptions(rawValue: 0x1)
    
    /// Specifies the format of data in a compute buffer as being 8x2.
    public static let computeFormat8x2 = BufferOptions(rawValue: 0x2)
    
    /// Specifies the format of data in a compute buffer as being 8x4.
    public static let computeFormat8x4 = BufferOptions(rawValue: 0x3)
    
    /// Specifies the format of data in a compute buffer as being 16x1.
    public static let computeFormat16x1 = BufferOptions(rawValue: 0x4)
    
    /// Specifies the format of data in a compute buffer as being 16x2.
    public static let computeFormat16x2 = BufferOptions(rawValue: 0x5)
    
    /// Specifies the format of data in a compute buffer as being 16x4.
    public static let computeFormat16x4 = BufferOptions(rawValue: 0x6)
    
    /// Specifies the format of data in a compute buffer as being 32x1.
    public static let computeFormat32x1 = BufferOptions(rawValue: 0x7)
    
    /// Specifies the format of data in a compute buffer as being 32x2.
    public static let computeFormat32x2 = BufferOptions(rawValue: 0x8)
    
    /// Specifies the format of data in a compute buffer as being 32x4.
    public static let computeFormat32x4 = BufferOptions(rawValue: 0x9)
    
    /// Specifies the type of data in a compute buffer as being unsigned integers.
    public static let computeTypeUInt = BufferOptions(rawValue: 0x10)
    
    /// Specifies the type of data in a compute buffer as being signed integers.
    public static let computeTypeInt = BufferOptions(rawValue: 0x20)
    
    /// Specifies the type of data in a compute buffer as being floating point values.
    public static let computeTypeFloat = BufferOptions(rawValue: 0x30)
    
    /// Buffer will be read by a compute shader.
    public static let computeRead = BufferOptions(rawValue: 0x100)
    
    /// Buffer will be written into by a compute shader. It cannot be accessed by the CPU.
    public static let computeWrite = BufferOptions(rawValue: 0x200)
    
    /// Buffer is the source of indirect draw commands.
    public static let drawIndirect = BufferOptions(rawValue: 0x400)
    
    /// Buffer will resize on update if a different quantity of data is passed. If this flag is not set
    /// the data will be trimmed to fit in the existing buffer size. Effective only for dynamic buffers.
    public static let allowResize = BufferOptions(rawValue: 0x800)
    
    /// Buffer is using 32-bit indices. Useful only for index buffers.
    public static let index32 = BufferOptions(rawValue: 0x1000)
    
    /// Buffer will be read and written by a compute shader.
    public static let computeReadWrite = [BufferOptions.computeRead, BufferOptions.computeWrite]
}

/// Specifies various error types that can be reported by bgfx.
public enum BgfxError: UInt32 {
    /// A debug check failed; the program can safely continue, but the issue should be investigated.
    case debugCheck
    
    /// The user's hardware failed checks for the minimum required specs.
    case minimumRequiredSpecs
    
    /// The program tried to compile an invalid shader.
    case invalidShader
    
    /// An error occurred during bgfx library initialization.
    case unableToInitialize
    
    /// Failed while trying to create a texture.
    case unableToCreateTexture
    
    /// The graphics device was lost and the library was unable to recover.
    case deviceLost
}

/// Specifies results of an occlusion query.
public enum OcclusionQueryResult: UInt32 {
    /// Objects are invisible.
    case invisible
    
    /// Objects are visible.
    case visible
    
    /// Result is not ready or is unknown.
    case noResult
}

/// Specifies results of manually rendering a single frame
public enum RenderFrameResult: UInt32 {
    /// No device context has been created yet
    case nocontext = 0
    
    /// The frame was rendered
    case render
    
    /// Rendering is done; the program should exit
    case exiting
}
