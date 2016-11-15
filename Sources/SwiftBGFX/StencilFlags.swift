// Copyright 2016 Stuart Carnie.
// License: https://github.com/stuartcarnie/SwiftBGFX#license-bsd-2-clause
//

/// Specifies state information used to configure rendering operations
public struct StencilOptions : OptionSet {
    public let rawValue: UInt32
    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
    
    /// No state bits set.
    public static let none = StencilOptions(rawValue: 0)

    /// Perform a "less than" stencil test.
    public static let testLess = StencilOptions(rawValue: 0x00010000)

    /// Perform a "less than or equal" stencil test.
    public static let testLessEqual = StencilOptions(rawValue: 0x00020000)

    /// Perform an equality stencil test.
    public static let testEqual = StencilOptions(rawValue: 0x00030000)

    /// Perform a "greater than or equal" stencil test.
    public static let testGreaterEqual = StencilOptions(rawValue: 0x00040000)

    /// Perform a "greater than" stencil test.
    public static let testGreater = StencilOptions(rawValue: 0x00050000)

    /// Perform an inequality stencil test.
    public static let testNotEqual = StencilOptions(rawValue: 0x00060000)

    /// Never pass the stencil test.
    public static let testNever = StencilOptions(rawValue: 0x00070000)

    /// Always pass the stencil test.
    public static let testAlways = StencilOptions(rawValue: 0x00080000)

    /// On failing the stencil test, zero out the stencil value.
    public static let failSZero = StencilOptions(rawValue: 0x00000000)

    /// On failing the stencil test, keep the old stencil value.
    public static let failSKeep = StencilOptions(rawValue: 0x00100000)

    /// On failing the stencil test, replace the stencil value.
    public static let failSReplace = StencilOptions(rawValue: 0x00200000)

    /// On failing the stencil test, increment the stencil value.
    public static let failSIncrement = StencilOptions(rawValue: 0x00300000)

    /// On failing the stencil test, increment the stencil value (with saturation).
    public static let failSIncrementSaturate = StencilOptions(rawValue: 0x00400000)

    /// On failing the stencil test, decrement the stencil value.
    public static let failSDecrement = StencilOptions(rawValue: 0x00500000)

    /// On failing the stencil test, decrement the stencil value (with saturation).
    public static let failSDecrementSaturate = StencilOptions(rawValue: 0x00600000)

    /// On failing the stencil test, invert the stencil value.
    public static let failSInvert = StencilOptions(rawValue: 0x00700000)

    /// On failing the stencil test, zero out the depth value.
    public static let failZZero = StencilOptions(rawValue: 0x00000000)

    /// On failing the stencil test, keep the depth value.
    public static let failZKeep = StencilOptions(rawValue: 0x01000000)

    /// On failing the stencil test, replace the depth value.
    public static let failZReplace = StencilOptions(rawValue: 0x02000000)

    /// On failing the stencil test, increment the depth value.
    public static let failZIncrement = StencilOptions(rawValue: 0x03000000)

    /// On failing the stencil test, increment the depth value (with saturation).
    public static let failZIncrementSaturate = StencilOptions(rawValue: 0x04000000)

    /// On failing the stencil test, decrement the depth value.
    public static let failZDecrement = StencilOptions(rawValue: 0x05000000)

    /// On failing the stencil test, decrement the depth value (with saturation).
    public static let failZDecrementSaturate = StencilOptions(rawValue: 0x06000000)

    /// On failing the stencil test, invert the depth value.
    public static let failZInvert = StencilOptions(rawValue: 0x07000000)

    /// On passing the stencil test, zero out the depth value.
    public static let passZZero = StencilOptions(rawValue: 0x00000000)

    /// On passing the stencil test, keep the old depth value.
    public static let passZKeep = StencilOptions(rawValue: 0x10000000)

    /// On passing the stencil test, replace the depth value.
    public static let passZReplace = StencilOptions(rawValue: 0x20000000)

    /// On passing the stencil test, increment the depth value.
    public static let passZIncrement = StencilOptions(rawValue: 0x30000000)

    /// On passing the stencil test, increment the depth value (with saturation).
    public static let passZIncrementSaturate = StencilOptions(rawValue: 0x40000000)

    /// On passing the stencil test, decrement the depth value.
    public static let passZDecrement = StencilOptions(rawValue: 0x50000000)

    /// On passing the stencil test, decrement the depth value (with saturation).
    public static let passZDecrementSaturate = StencilOptions(rawValue: 0x60000000)

    /// On passing the stencil test, invert the depth value.
    public static let passZInvert = StencilOptions(rawValue: 0x70000000)

    /// Encodes a reference value in a stencil state
    ///
    /// - parameter reference: The stencil reference value
    ///
    /// - returns: The encoded stencil state
    public static func referenceValue(_ reference: UInt8) -> StencilOptions {
        return StencilOptions(rawValue: UInt32(reference))
    }

    /// Encodes a read mask in a stencil state
    ///
    /// - parameter mask: The mask
    ///
    /// - returns: The encoded stencil state
    public static func readMask(_ mask: UInt8) -> StencilOptions {
        return StencilOptions(rawValue: (UInt32(mask) << ReadMaskShift) & ReadMaskMask)
    }

    static let ReadMaskShift:UInt32 = 8;
    static let ReadMaskMask:UInt32 = 0x0000ff00;

    public static func &(lhs: StencilOptions, rhs: StencilOptions) -> StencilOptions {
        return StencilOptions(rawValue: lhs.rawValue & rhs.rawValue)
    }

    public static func <<(lhs: StencilOptions, rhs: Int) -> StencilOptions {
        return StencilOptions(rawValue: lhs.rawValue << UInt32(rhs))
    }
}
