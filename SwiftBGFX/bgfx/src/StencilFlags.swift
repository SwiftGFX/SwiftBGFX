// Copyright 2016 Stuart Carnie.
// License: https://github.com/stuartcarnie/SwiftBGFX#license-bsd-2-clause
//

/// Specifies state information used to configure rendering operations
public struct StencilFlags : OptionSet {
    public let rawValue: UInt32
    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
    
    /// No state bits set.
    public static let None = StencilFlags(rawValue: 0)
    
    /// Perform a "less than" stencil test.
    public static let TestLess = StencilFlags(rawValue: 0x00010000)
    
    /// Perform a "less than or equal" stencil test.
    public static let TestLessEqual = StencilFlags(rawValue: 0x00020000)
    
    /// Perform an equality stencil test.
    public static let TestEqual = StencilFlags(rawValue: 0x00030000)
    
    /// Perform a "greater than or equal" stencil test.
    public static let TestGreaterEqual = StencilFlags(rawValue: 0x00040000)
    
    /// Perform a "greater than" stencil test.
    public static let TestGreater = StencilFlags(rawValue: 0x00050000)
    
    /// Perform an inequality stencil test.
    public static let TestNotEqual = StencilFlags(rawValue: 0x00060000)
    
    /// Never pass the stencil test.
    public static let TestNever = StencilFlags(rawValue: 0x00070000)
    
    /// Always pass the stencil test.
    public static let TestAlways = StencilFlags(rawValue: 0x00080000)
    
    /// On failing the stencil test, zero out the stencil value.
    public static let FailSZero = StencilFlags(rawValue: 0x00000000)
    
    /// On failing the stencil test, keep the old stencil value.
    public static let FailSKeep = StencilFlags(rawValue: 0x00100000)
    
    /// On failing the stencil test, replace the stencil value.
    public static let FailSReplace = StencilFlags(rawValue: 0x00200000)
    
    /// On failing the stencil test, increment the stencil value.
    public static let FailSIncrement = StencilFlags(rawValue: 0x00300000)
    
    /// On failing the stencil test, increment the stencil value (with saturation).
    public static let FailSIncrementSaturate = StencilFlags(rawValue: 0x00400000)
    
    /// On failing the stencil test, decrement the stencil value.
    public static let FailSDecrement = StencilFlags(rawValue: 0x00500000)
    
    /// On failing the stencil test, decrement the stencil value (with saturation).
    public static let FailSDecrementSaturate = StencilFlags(rawValue: 0x00600000)
    
    /// On failing the stencil test, invert the stencil value.
    public static let FailSInvert = StencilFlags(rawValue: 0x00700000)
    
    /// On failing the stencil test, zero out the depth value.
    public static let FailZZero = StencilFlags(rawValue: 0x00000000)
    
    /// On failing the stencil test, keep the depth value.
    public static let FailZKeep = StencilFlags(rawValue: 0x01000000)
    
    /// On failing the stencil test, replace the depth value.
    public static let FailZReplace = StencilFlags(rawValue: 0x02000000)
    
    /// On failing the stencil test, increment the depth value.
    public static let FailZIncrement = StencilFlags(rawValue: 0x03000000)
    
    /// On failing the stencil test, increment the depth value (with saturation).
    public static let FailZIncrementSaturate = StencilFlags(rawValue: 0x04000000)
    
    /// On failing the stencil test, decrement the depth value.
    public static let FailZDecrement = StencilFlags(rawValue: 0x05000000)
    
    /// On failing the stencil test, decrement the depth value (with saturation).
    public static let FailZDecrementSaturate = StencilFlags(rawValue: 0x06000000)
    
    /// On failing the stencil test, invert the depth value.
    public static let FailZInvert = StencilFlags(rawValue: 0x07000000)
    
    /// On passing the stencil test, zero out the depth value.
    public static let PassZZero = StencilFlags(rawValue: 0x00000000)
    
    /// On passing the stencil test, keep the old depth value.
    public static let PassZKeep = StencilFlags(rawValue: 0x10000000)
    
    /// On passing the stencil test, replace the depth value.
    public static let PassZReplace = StencilFlags(rawValue: 0x20000000)
    
    /// On passing the stencil test, increment the depth value.
    public static let PassZIncrement = StencilFlags(rawValue: 0x30000000)
    
    /// On passing the stencil test, increment the depth value (with saturation).
    public static let PassZIncrementSaturate = StencilFlags(rawValue: 0x40000000)
    
    /// On passing the stencil test, decrement the depth value.
    public static let PassZDecrement = StencilFlags(rawValue: 0x50000000)
    
    /// On passing the stencil test, decrement the depth value (with saturation).
    public static let PassZDecrementSaturate = StencilFlags(rawValue: 0x60000000)
    
    /// On passing the stencil test, invert the depth value.
    public static let PassZInvert = StencilFlags(rawValue: 0x70000000)

    /// Encodes a reference value in a stencil state
    ///
    /// - parameter reference: The stencil reference value
    ///
    /// - returns: The encoded stencil state
    public static func referenceValue(_ reference: UInt8) -> StencilFlags {
        return StencilFlags(rawValue: UInt32(reference))
    }

    /// Encodes a read mask in a stencil state
    ///
    /// - parameter mask: The mask
    ///
    /// - returns: The encoded stencil state
    public static func readMask(_ mask: UInt8) -> StencilFlags {
        return StencilFlags(rawValue: (UInt32(mask) << ReadMaskShift) & ReadMaskMask)
    }

    static let ReadMaskShift:UInt32 = 8;
    static let ReadMaskMask:UInt32 = 0x0000ff00;
}

func &(lhs: StencilFlags, rhs: StencilFlags) -> StencilFlags {
    return StencilFlags(rawValue: lhs.rawValue & rhs.rawValue)
}

func <<(lhs: StencilFlags, rhs: Int) -> StencilFlags {
    return StencilFlags(rawValue: lhs.rawValue << UInt32(rhs))
}
