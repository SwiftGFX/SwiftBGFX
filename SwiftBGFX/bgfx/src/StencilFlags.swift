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
    public static let none = StencilFlags(rawValue: 0)

    /// Perform a "less than" stencil test.
    public static let testLess = StencilFlags(rawValue: 0x00010000)

    /// Perform a "less than or equal" stencil test.
    public static let testLessEqual = StencilFlags(rawValue: 0x00020000)

    /// Perform an equality stencil test.
    public static let testEqual = StencilFlags(rawValue: 0x00030000)

    /// Perform a "greater than or equal" stencil test.
    public static let testGreaterEqual = StencilFlags(rawValue: 0x00040000)

    /// Perform a "greater than" stencil test.
    public static let testGreater = StencilFlags(rawValue: 0x00050000)

    /// Perform an inequality stencil test.
    public static let testNotEqual = StencilFlags(rawValue: 0x00060000)

    /// Never pass the stencil test.
    public static let testNever = StencilFlags(rawValue: 0x00070000)

    /// Always pass the stencil test.
    public static let testAlways = StencilFlags(rawValue: 0x00080000)

    /// On failing the stencil test, zero out the stencil value.
    public static let failSZero = StencilFlags(rawValue: 0x00000000)

    /// On failing the stencil test, keep the old stencil value.
    public static let failSKeep = StencilFlags(rawValue: 0x00100000)

    /// On failing the stencil test, replace the stencil value.
    public static let failSReplace = StencilFlags(rawValue: 0x00200000)

    /// On failing the stencil test, increment the stencil value.
    public static let failSIncrement = StencilFlags(rawValue: 0x00300000)

    /// On failing the stencil test, increment the stencil value (with saturation).
    public static let failSIncrementSaturate = StencilFlags(rawValue: 0x00400000)

    /// On failing the stencil test, decrement the stencil value.
    public static let failSDecrement = StencilFlags(rawValue: 0x00500000)

    /// On failing the stencil test, decrement the stencil value (with saturation).
    public static let failSDecrementSaturate = StencilFlags(rawValue: 0x00600000)

    /// On failing the stencil test, invert the stencil value.
    public static let failSInvert = StencilFlags(rawValue: 0x00700000)

    /// On failing the stencil test, zero out the depth value.
    public static let failZZero = StencilFlags(rawValue: 0x00000000)

    /// On failing the stencil test, keep the depth value.
    public static let failZKeep = StencilFlags(rawValue: 0x01000000)

    /// On failing the stencil test, replace the depth value.
    public static let failZReplace = StencilFlags(rawValue: 0x02000000)

    /// On failing the stencil test, increment the depth value.
    public static let failZIncrement = StencilFlags(rawValue: 0x03000000)

    /// On failing the stencil test, increment the depth value (with saturation).
    public static let failZIncrementSaturate = StencilFlags(rawValue: 0x04000000)

    /// On failing the stencil test, decrement the depth value.
    public static let failZDecrement = StencilFlags(rawValue: 0x05000000)

    /// On failing the stencil test, decrement the depth value (with saturation).
    public static let failZDecrementSaturate = StencilFlags(rawValue: 0x06000000)

    /// On failing the stencil test, invert the depth value.
    public static let failZInvert = StencilFlags(rawValue: 0x07000000)

    /// On passing the stencil test, zero out the depth value.
    public static let passZZero = StencilFlags(rawValue: 0x00000000)

    /// On passing the stencil test, keep the old depth value.
    public static let passZKeep = StencilFlags(rawValue: 0x10000000)

    /// On passing the stencil test, replace the depth value.
    public static let passZReplace = StencilFlags(rawValue: 0x20000000)

    /// On passing the stencil test, increment the depth value.
    public static let passZIncrement = StencilFlags(rawValue: 0x30000000)

    /// On passing the stencil test, increment the depth value (with saturation).
    public static let passZIncrementSaturate = StencilFlags(rawValue: 0x40000000)

    /// On passing the stencil test, decrement the depth value.
    public static let passZDecrement = StencilFlags(rawValue: 0x50000000)

    /// On passing the stencil test, decrement the depth value (with saturation).
    public static let passZDecrementSaturate = StencilFlags(rawValue: 0x60000000)

    /// On passing the stencil test, invert the depth value.
    public static let passZInvert = StencilFlags(rawValue: 0x70000000)

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

    public static func &(lhs: StencilFlags, rhs: StencilFlags) -> StencilFlags {
        return StencilFlags(rawValue: lhs.rawValue & rhs.rawValue)
    }

    public static func <<(lhs: StencilFlags, rhs: Int) -> StencilFlags {
        return StencilFlags(rawValue: lhs.rawValue << UInt32(rhs))
    }
}
