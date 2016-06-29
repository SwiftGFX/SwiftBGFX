//
//  renderstate.swift
//  bgfx Test
//
//  Created by Stuart Carnie on 4/22/16.
//  Copyright © 2016 SGC. All rights reserved.
//

public struct RenderState: OptionSet {
    public let rawValue: UInt64
    public init(rawValue: UInt64) {
        self.rawValue = rawValue
    }

    /// No state bits set.
    public static let None = RenderState(rawValue: 0)

    /// Enable writing color data to the framebuffer.
    public static let ColorWrite = RenderState(rawValue: 0x0000000000000001)

    /// Enable writing alpha data to the framebuffer.
    public static let AlphaWrite = RenderState(rawValue: 0x0000000000000002)

    /// Enable writing to the depth buffer.
    public static let DepthWrite = RenderState(rawValue: 0x0000000000000004)

    /// Use a "less than" comparison to pass the depth test.
    public static let DepthTestLess = RenderState(rawValue: 0x0000000000000010)

    /// Use a "less than or equal to" comparison to pass the depth test.
    public static let DepthTestLessEqual = RenderState(rawValue: 0x0000000000000020)

    /// Pass the depth test if both values are equal.
    public static let DepthTestEqual = RenderState(rawValue: 0x0000000000000030)

    /// Use a "greater than or equal to" comparison to pass the depth test.
    public static let DepthTestGreaterEqual = RenderState(rawValue: 0x0000000000000040)

    /// Use a "greater than" comparison to pass the depth test.
    public static let DepthTestGreater = RenderState(rawValue: 0x0000000000000050)

    /// Pass the depth test if both values are not equal.
    public static let DepthTestNotEqual = RenderState(rawValue: 0x0000000000000060)

    /// Never pass the depth test.
    public static let DepthTestNever = RenderState(rawValue: 0x0000000000000070)

    /// Always pass the depth test.
    public static let DepthTestAlways = RenderState(rawValue: 0x0000000000000080)

    /// Use a value of 0 as an input to a blend equation.
    public static let BlendZero = RenderState(rawValue: 0x0000000000001000)

    /// Use a value of 1 as an input to a blend equation.
    public static let BlendOne = RenderState(rawValue: 0x0000000000002000)

    /// Use the source pixel color as an input to a blend equation.
    public static let BlendSourceColor = RenderState(rawValue: 0x0000000000003000)

    /// Use one minus the source pixel color as an input to a blend equation.
    public static let BlendInverseSourceColor = RenderState(rawValue: 0x0000000000004000)

    /// Use the source pixel alpha as an input to a blend equation.
    public static let BlendSourceAlpha = RenderState(rawValue: 0x0000000000005000)

    /// Use one minus the source pixel alpha as an input to a blend equation.
    public static let BlendInverseSourceAlpha = RenderState(rawValue: 0x0000000000006000)

    /// Use the destination pixel alpha as an input to a blend equation.
    public static let BlendDestinationAlpha = RenderState(rawValue: 0x0000000000007000)

    /// Use one minus the destination pixel alpha as an input to a blend equation.
    public static let BlendInverseDestinationAlpha = RenderState(rawValue: 0x0000000000008000)

    /// Use the destination pixel color as an input to a blend equation.
    public static let BlendDestinationColor = RenderState(rawValue: 0x0000000000009000)

    /// Use one minus the destination pixel color as an input to a blend equation.
    public static let BlendInverseDestinationColor = RenderState(rawValue: 0x000000000000a000)

    /// Use the source pixel alpha (saturated) as an input to a blend equation.
    public static let BlendSourceAlphaSaturate = RenderState(rawValue: 0x000000000000b000)

    /// Use an application supplied blending factor as an input to a blend equation.
    public static let BlendFactor = RenderState(rawValue: 0x000000000000c000)

    /// Use one minus an application supplied blending factor as an input to a blend equation.
    public static let BlendInverseFactor = RenderState(rawValue: 0x000000000000d000)

    /// Blend equation: A + B
    public static let BlendEquationAdd = RenderState(rawValue: 0x0000000000000000)

    /// Blend equation: B - A
    public static let BlendEquationSub = RenderState(rawValue: 0x0000000010000000)

    /// Blend equation: A - B
    public static let BlendEquationReverseSub = RenderState(rawValue: 0x0000000020000000)

    /// Blend equation: min(a, b)
    public static let BlendEquationMin = RenderState(rawValue: 0x0000000030000000)

    /// Blend equation: max(a, b)
    public static let BlendEquationMax = RenderState(rawValue: 0x0000000040000000)

    /// Enable independent blending of simultaenous render targets.
    public static let BlendIndependent = RenderState(rawValue: 0x0000000400000000)

    /// Enable alpha to coverage blending.
    public static let BlendAlphaToCoverage = RenderState(rawValue: 0x0000000800000000)

    /// Don't perform culling of back faces.
    public static let NoCulling = RenderState(rawValue: 0x0000000000000000)

    /// Perform culling of clockwise faces.
    public static let CullClockwise = RenderState(rawValue: 0x0000001000000000)

    /// Perform culling of counter-clockwise faces.
    public static let CullCounterclockwise = RenderState(rawValue: 0x0000002000000000)

    /// Primitive topology: triangle list.
    public static let PrimitiveTriangles = RenderState(rawValue: 0x0000000000000000)

    /// Primitive topology: triangle strip.
    public static let PrimitiveTriangleStrip = RenderState(rawValue: 0x0001000000000000)

    /// Primitive topology: line list.
    public static let PrimitiveLines = RenderState(rawValue: 0x0002000000000000)

    /// Primitive topology: line strip.
    public static let PrimitiveLineStrip = RenderState(rawValue: 0x0003000000000000)

    /// Primitive topology: point list.
    public static let PrimitivePoints = RenderState(rawValue: 0x0004000000000000)

    /// Enable multisampling.
    public static let Multisampling = RenderState(rawValue: 0x1000000000000000)

    /// Enable line antialiasing.
    public static let LineAA = RenderState(rawValue: 0x2000000000000000)

    /// Enable conservative rasterization.
    public static let ConservativeRasterization = RenderState(rawValue: 0x4000000000000000)

    /// Provides a set of sane defaults
    public static let Default: RenderState = [ColorWrite, AlphaWrite, DepthWrite, DepthTestLess, CullClockwise, Multisampling]

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
    /// - parameters:
    ///
    ///    - source: The source blend operation
    ///    - destination: The destination blend operation
    ///
    /// - returns: The render state for the blend function
    public static func blendFunction(_ source: RenderState, destination: RenderState) -> RenderState {
        return blendFunction(source, destinationColor: destination, sourceAlpha: source, destinationAlpha: destination)
    }

    /// Builds a render state for a blend function
    ///
    /// - parameters:
    ///
    ///    - sourceColor: The source color blend operation
    ///    - destinationColor: The destination color blend operation
    ///    - source:Alpha The source alpha blend operation
    ///    - destinationAlpha: The destination alpha blend operation
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
    /// - parameters
    ///    - sourceEquation: The source equation
    ///    - alphaEquation: The alpha equation
    ///
    /// - returns: The render state for the blend equation
    public static func blendEquation(_ sourceEquation: RenderState, alphaEquation: RenderState) -> RenderState {
        return sourceEquation | (alphaEquation << 3)
    }

    static let AlphaRefShift: UInt64 = 40
    static let PointSizeShift: UInt64 = 52
    static let AlphaRefMask: UInt64 = 0x0000ff0000000000
    static let PointSizeMask: UInt64 = 0x0ff0000000000000
}

public func |(lhs: RenderState, rhs: RenderState) -> RenderState {
    return RenderState(rawValue: lhs.rawValue | rhs.rawValue)
}

public func <<(lhs: RenderState, rhs: Int) -> RenderState {
    return RenderState(rawValue: lhs.rawValue << UInt64(rhs))
}
