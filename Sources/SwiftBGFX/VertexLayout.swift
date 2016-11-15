// Copyright 2016 Stuart Carnie.
// License: https://github.com/stuartcarnie/SwiftBGFX#license-bsd-2-clause
//

import Cbgfx

/// Describes the layout of data in a vertex stream
final public class VertexLayout {
    var handle = bgfx_vertex_decl_t()
	
	public init() {
		
	}
    
    /// The stride of a single vertex using this layout
    public var stride: UInt16 {
        return handle.stride
    }
    
    /// Starts a stream of vertex attribute additions to the layout
    ///
    /// - returns: `self`
    public func begin(renderer: RendererBackend = .none) -> Self {
        bgfx_vertex_decl_begin(&handle, bgfx_renderer_type_t(renderer.rawValue))
        return self
    }

    /// Marks the end of the vertex stream
    public func end() {
        bgfx_vertex_decl_end(&handle)
    }
    
    /// Add attribute to VertexDecl
    ///
    /// - parameter attrib: The kind of attribute to add
    /// - parameter num: Number of elements (1, 2, 3 or 4)
    /// - parameter type: The type of data described by the attribute
    /// - parameter normalized:
    ///     When using fixed point AttribType (f.e. `UInt8`) value will be normalized
    ///     for vertex shader usage. When normalized is set to true,
    ///     `AttribType.Uint8` value in range 0-255 will be in range 0.0-1.0 in
    ///     vertex shader
    /// - parameter asInt:
    ///     Packaging rule for `vertexPack`, `vertexUnpack`, and `vertexConvert` for
    ///     `AttribType::UInt8` and `AttribType.Int16`. Unpacking code must be
    ///     implemented inside vertex shader
    ///
    /// - returns: `self`
    ///
    /// - remark: Must be called between `begin`/`end`
    public func add(attrib: VertexAttributeUsage, num: UInt8, type: VertexAttribType, normalized: Bool = false, asInt: Bool = false) -> Self {
        bgfx_vertex_decl_add(&handle, bgfx_attrib_t(attrib.rawValue), num, bgfx_attrib_type_t(type.rawValue), normalized, asInt)
        return self
    }
    
    /// Skip `num` bytes in vertex stream
    ///
    /// - returns: `Self`
    public func skip(num: UInt8) -> Self {
        bgfx_vertex_decl_skip(&handle, num)
        return self
    }
    
    //    func decode(attrib: Attrib, inout num: UInt8, inout type: AttribType, inout normalized: Bool, inout asInt: Bool) -> Self {
    //
    //        return self
    //    }
}
