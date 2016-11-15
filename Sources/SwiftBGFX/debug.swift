// Copyright 2016 Stuart Carnie.
// License: https://github.com/stuartcarnie/SwiftBGFX#license-bsd-2-clause
//

/// Specifies flags for various options when debugging bgfx
public struct DebugOptions: OptionSet {
    public let rawValue: UInt32
    
    public init(rawValue: UInt32) { self.rawValue = rawValue }
    
    /// Don't enable any debugging features
    public static let none = DebugOptions(rawValue: 0x0000_0000)
    
    /// Enable wireframe for all primitives
    public static let wireframe = DebugOptions(rawValue: 0x0000_0001)
    
    /// Enable infinitely fast hardware test. No draw calls will be submitted to
    /// driver. It’s useful when profiling to quickly assess bottleneck between CPU and GPU.
    public static let IFH = DebugOptions(rawValue: 0x0000_0002)
    
    /// Display internal statistics
    public static let stats = DebugOptions(rawValue: 0x0000_0004)
    
    /// Enable debug text display
    public static let text = DebugOptions(rawValue: 0x0000_0008)
}

/// Specifies debug text colors.
public enum DebugColor: UInt8 {
    /// Transparent.
    case transparent = 0
    
    /// Red.
    case red
    
    /// Green.
    case green
    
    /// Yellow.
    case yellow
    
    /// Blue.
    case blue
    
    /// Purple.
    case purple
    
    /// Cyan.
    case cyan
    
    /// Gray.
    case gray
    
    /// Dark gray.
    case darkGray
    
    /// Light red.
    case lightRed
    
    /// Light green.
    case lightGreen
    
    /// Light yellow.
    case lightYellow
    
    /// Light blue.
    case lightBlue
    
    /// Light purple.
    case lightPurple
    
    /// Light cyan.
    case lightCyan
    
    /// White.
    case white
}
