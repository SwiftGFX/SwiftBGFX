// Copyright 2016 Stuart Carnie.
// License: https://github.com/stuartcarnie/SwiftBGFX#license-bsd-2-clause
//

public struct RenderState: OptionSet {
    public let rawValue: UInt64
    public init(rawValue: UInt64) {
        self.rawValue = rawValue
    }

    /// No state bits set.
    public static let none = RenderState(rawValue: 0)

    /// Enable writing color data to the framebuffer.
    public static let colorWrite = RenderState(rawValue: 0x0000000000000001)

    /// Enable writing alpha data to the framebuffer.
    public static let alphaWrite = RenderState(rawValue: 0x0000000000000002)

    /// Enable writing to the depth buffer.
    public static let depthWrite = RenderState(rawValue: 0x0000000000000004)

    /// Use a "less than" comparison to pass the depth test.
    public static let depthTestLess = RenderState(rawValue: 0x0000000000000010)

    /// Use a "less than or equal to" comparison to pass the depth test.
    public static let depthTestLessEqual = RenderState(rawValue: 0x0000000000000020)

    /// Pass the depth test if both values are equal.
    public static let depthTestEqual = RenderState(rawValue: 0x0000000000000030)

    /// Use a "greater than or equal to" comparison to pass the depth test.
    public static let depthTestGreaterEqual = RenderState(rawValue: 0x0000000000000040)

    /// Use a "greater than" comparison to pass the depth test.
    public static let depthTestGreater = RenderState(rawValue: 0x0000000000000050)

    /// Pass the depth test if both values are not equal.
    public static let depthTestNotEqual = RenderState(rawValue: 0x0000000000000060)

    /// Never pass the depth test.
    public static let depthTestNever = RenderState(rawValue: 0x0000000000000070)

    /// Always pass the depth test.
    public static let depthTestAlways = RenderState(rawValue: 0x0000000000000080)

    /// Use a value of 0 as an input to a blend equation.
    public static let blendZero = RenderState(rawValue: 0x0000000000001000)

    /// Use a value of 1 as an input to a blend equation.
    public static let blendOne = RenderState(rawValue: 0x0000000000002000)

    /// Use the source pixel color as an input to a blend equation.
    public static let blendSourceColor = RenderState(rawValue: 0x0000000000003000)

    /// Use one minus the source pixel color as an input to a blend equation.
    public static let blendInverseSourceColor = RenderState(rawValue: 0x0000000000004000)

    /// Use the source pixel alpha as an input to a blend equation.
    public static let blendSourceAlpha = RenderState(rawValue: 0x0000000000005000)

    /// Use one minus the source pixel alpha as an input to a blend equation.
    public static let blendInverseSourceAlpha = RenderState(rawValue: 0x0000000000006000)

    /// Use the destination pixel alpha as an input to a blend equation.
    public static let blendDestinationAlpha = RenderState(rawValue: 0x0000000000007000)

    /// Use one minus the destination pixel alpha as an input to a blend equation.
    public static let blendInverseDestinationAlpha = RenderState(rawValue: 0x0000000000008000)

    /// Use the destination pixel color as an input to a blend equation.
    public static let blendDestinationColor = RenderState(rawValue: 0x0000000000009000)

    /// Use one minus the destination pixel color as an input to a blend equation.
    public static let blendInverseDestinationColor = RenderState(rawValue: 0x000000000000a000)

    /// Use the source pixel alpha (saturated) as an input to a blend equation.
    public static let blendSourceAlphaSaturate = RenderState(rawValue: 0x000000000000b000)

    /// Use an application supplied blending factor as an input to a blend equation.
    public static let blendFactor = RenderState(rawValue: 0x000000000000c000)

    /// Use one minus an application supplied blending factor as an input to a blend equation.
    public static let blendInverseFactor = RenderState(rawValue: 0x000000000000d000)

    /// Blend equation: A + B
    public static let blendEquationAdd = RenderState(rawValue: 0x0000000000000000)

    /// Blend equation: B - A
    public static let blendEquationSub = RenderState(rawValue: 0x0000000010000000)

    /// Blend equation: A - B
    public static let blendEquationReverseSub = RenderState(rawValue: 0x0000000020000000)

    /// Blend equation: min(a, b)
    public static let blendEquationMin = RenderState(rawValue: 0x0000000030000000)

    /// Blend equation: max(a, b)
    public static let blendEquationMax = RenderState(rawValue: 0x0000000040000000)

    /// Enable independent blending of simultaenous render targets.
    public static let blendIndependent = RenderState(rawValue: 0x0000000400000000)

    /// Enable alpha to coverage blending.
    public static let blendAlphaToCoverage = RenderState(rawValue: 0x0000000800000000)

    /// Don't perform culling of back faces.
    public static let noCulling = RenderState(rawValue: 0x0000000000000000)

    /// Perform culling of clockwise faces.
    public static let cullClockwise = RenderState(rawValue: 0x0000001000000000)

    /// Perform culling of counter-clockwise faces.
    public static let cullCounterclockwise = RenderState(rawValue: 0x0000002000000000)

    /// Primitive topology: triangle list.
    public static let primitiveTriangles = RenderState(rawValue: 0x0000000000000000)

    /// Primitive topology: triangle strip.
    public static let primitiveTriangleStrip = RenderState(rawValue: 0x0001000000000000)

    /// Primitive topology: line list.
    public static let primitiveLines = RenderState(rawValue: 0x0002000000000000)

    /// Primitive topology: line strip.
    public static let primitiveLineStrip = RenderState(rawValue: 0x0003000000000000)

    /// Primitive topology: point list.
    public static let primitivePoints = RenderState(rawValue: 0x0004000000000000)

    /// Enable multisampling.
    public static let multisampling = RenderState(rawValue: 0x1000000000000000)

    /// Enable line antialiasing.
    public static let lineAA = RenderState(rawValue: 0x2000000000000000)

    /// Enable conservative rasterization.
    public static let conservativeRasterization = RenderState(rawValue: 0x4000000000000000)

    /// Provides a set of sane defaults
    public static let `default`: RenderState = [colorWrite, alphaWrite, depthWrite, depthTestLess, cullClockwise, multisampling]

    /// Encodes an alpha reference value in a render state
    ///
    /// - parameter alpha: The alpha reference value
    ///
    /// - returns: The encoded render state
    public static func alphaRef(_ alpha: UInt8) -> RenderState {
        return RenderState(rawValue: (UInt64(alpha) << AlphaRefShift) & AlphaRefMask)
    }

    /// Encodes a point size value in a render state
    ///
    /// - parameter alpha: The point size
    ///
    /// - returns: The encoded render state
    public static func pointSize(_ size: UInt8) -> RenderState {
        return RenderState(rawValue: (UInt64(size) << PointSizeShift) & PointSizeMask)
    }

    /// Builds a render state for a blend function
    ///
    /// - parameter source: The source blend operation
    /// - parameter destination: The destination blend operation
    ///
    /// - returns: The render state for the blend function
    public static func blendFunction(_ source: RenderState, destination: RenderState) -> RenderState {
        return blendFunction(source, destinationColor: destination, sourceAlpha: source, destinationAlpha: destination)
    }

    /// Builds a render state for a blend function
    ///
    /// - parameter sourceColor: The source color blend operation
    /// - parameter destinationColor: The destination color blend operation
    /// - parameter source:Alpha The source alpha blend operation
    /// - parameter destinationAlpha: The destination alpha blend operation
    ///
    /// - returns: The render state for the blend function
    public static func blendFunction(_ sourceColor: RenderState, destinationColor: RenderState,
                                     sourceAlpha: RenderState, destinationAlpha: RenderState) -> RenderState {
        return (sourceColor | (destinationColor << 4)) | ((sourceAlpha | (destinationAlpha << 4)) << 8)
    }

    /// Builds a render state for a blend equation
    ///
    /// - parameter equation: The equation
    ///
    /// - returns: The render state for the blend equation
    public static func blendEquation(_ equation: RenderState) -> RenderState {
        return blendEquation(equation, alphaEquation: equation)
    }

    /// Builds a render state for a blend equation
    ///
    /// - parameter sourceEquation: The source equation
    /// - parameter alphaEquation: The alpha equation
    ///
    /// - returns: The render state for the blend equation
    public static func blendEquation(_ sourceEquation: RenderState, alphaEquation: RenderState) -> RenderState {
        return sourceEquation | (alphaEquation << 3)
    }

    static let AlphaRefShift: UInt64 = 40
    static let PointSizeShift: UInt64 = 52
    static let AlphaRefMask: UInt64 = 0x0000ff0000000000
    static let PointSizeMask: UInt64 = 0x0ff0000000000000

    public static func |(lhs: RenderState, rhs: RenderState) -> RenderState {
        return RenderState(rawValue: lhs.rawValue | rhs.rawValue)
    }

    public static func <<(lhs: RenderState, rhs: Int) -> RenderState {
        return RenderState(rawValue: lhs.rawValue << UInt64(rhs))
    }

}

