//
//  bgfx.swift
//  bgfx Test
//
//  Created by Stuart Carnie on 4/22/16.
//  Copyright © 2016 SGC. All rights reserved.
//

import SwiftMath

public class bgfx {

    /// Checks for available space to allocate transient index and vertex buffers
    ///
    /// - parameters:
    ///
    ///    - vertexCount: The number of vertices to allocate
    ///    - layout: The layout of each vertex
    ///    - indexCount: The number of indices to allocate
    ///
    /// - returns: `true` if there is sufficient space for both vertex and index buffers
    public static func checkAvailableTransientBufferSpace(_ vertexCount: UInt32, layout: VertexLayout, indexCount: UInt32) -> Bool {
        return bgfx_check_avail_transient_buffers(vertexCount, &layout.handle, indexCount)
    }

    /// Attempts to allocate both a transient vertex buffer and index buffer
    ///
    /// - parameters:
    ///
    ///    - vertexCount: The number of vertices to allocate
    ///    - layout: The layout of each vertex
    ///    - indexCount: The number of indices to allocate
    ///    - vertexBuffer: Returns the allocated transient vertex buffer
    ///    - indexBuffer: Returns the allocated transient index buffer
    ///
    /// - returns: `true` if both space requirements are satisfied and the buffers were allocated
    @discardableResult
    public static func allocateTransientBuffers(_ vertexCount: UInt32, layout: VertexLayout, indexCount: UInt32,
                                                vertexBuffer: inout TransientVertexBuffer,
                                                indexBuffer: inout TransientIndexBuffer) -> Bool {
        return _allocateTransientBuffers(vertexCount, layout: layout, indexCount: indexCount, vertexBuffer: &vertexBuffer, indexBuffer: &indexBuffer)
    }

    private static func _allocateTransientBuffers(_ vertexCount: UInt32, layout: VertexLayout, indexCount: UInt32,
                                                  vertexBuffer: UnsafeMutablePointer<TransientVertexBuffer>,
                                                  indexBuffer: UnsafeMutablePointer<TransientIndexBuffer>) -> Bool {
        let pvb = unsafeBitCast(vertexBuffer, to: UnsafeMutablePointer<bgfx_transient_vertex_buffer_t>.self)
        let pib = unsafeBitCast(indexBuffer, to: UnsafeMutablePointer<bgfx_transient_index_buffer_t>.self)
        return bgfx_alloc_transient_buffers(pvb, &layout.handle, vertexCount, pib, indexCount)
    }

    /// Packs a vector into vertex stream format
    ///
    /// - parameters:
    ///
    ///    - input: The four element vector to pack
    ///    - inputNormalized: `true` if the input vector is normalized
    ///    - attribute: The attribute usage of the vector data
    ///    - layout: The layout of the vertex stream
    ///    - data: The pointer to the vertex data stream
    ///    - index: The index of the vertex within the stream
    public static func vertexPack(_ input: Vector4f, inputNormalized: Bool, attribute: VertexAttributeUsage,
                                  layout: VertexLayout, data: UnsafeMutablePointer<Void>, index: UInt32 = 0) {
        typealias tuple = (CFloat, CFloat, CFloat, CFloat)
        var vec = unsafeBitCast(input, to: tuple.self)
        bgfx_vertex_pack(&vec.0, inputNormalized, bgfx_attrib_t(attribute.rawValue), &layout.handle, data, index)
    }

    /// Unpacks a vector from a vertex stream
    ///
    /// - parameters:
    ///
    ///    - output: A pointer to four floats that will receive the unpacked vector
    ///    - attribute: The attribute usage of the vector data
    ///    - layout: The layout of the vertex stream
    ///    - data: The pointer to the vertex data stream
    ///    - index: The index of the vertex within the stream
    public static func vertexUnpack(_ output: inout Vector4f, attribute: VertexAttributeUsage,
                                  layout: VertexLayout, data: UnsafeMutablePointer<Void>, index: UInt32 = 0) {
        let vec = toFloatPtr(&output)
        bgfx_vertex_unpack(vec, bgfx_attrib_t(attribute.rawValue), &layout.handle, data, index)
    }

    /// Converts a stream of vertex data from one format to another
    ///
    /// - parameters:
    ///
    ///    - destinationLayout: The destination vertext format
    ///    - destinationData: A pointer to the output location
    ///    - sourceLayout: The source vertext format
    ///    - sourceData: A pointer to the source data to convert
    ///    - count: The number of vertices to convert
    public static func vertexConvert(_ destinationLayout: VertexLayout, destinationData: UnsafeMutablePointer<Void>,
                                     sourceLayout: VertexLayout, sourceData: UnsafeMutablePointer<Void>,
                                     count: UInt32 = 1) {
        bgfx_vertex_convert(&destinationLayout.handle, destinationData, &sourceLayout.handle, sourceData, count);
    }
    
    /// Welds vertices that are close together
    /// 
    /// - parameters:
    /// 
    ///     - layout: The layout of the vertex stream
    ///     - data: A pointer to the vertex data stream
    ///     - count: The number of vertices in the stream
    ///     - remappingTable: An output remapping table from the original vertices to the welded ones
    ///     - epsilon: The tolerance for welding vertex positions
    ///
    /// - returns: The number of unique vertices after welding
    ///
    @discardableResult
    public static func weldVertices(_ layout: VertexLayout, data: UnsafeMutablePointer<Void>, count: UInt16, remappingTable: inout [UInt16], epsilon: Float = 0.001) -> UInt16 {
        remappingTable = [UInt16](repeating: 0, count: Int(count))
        return bgfx_weld_vertices(&remappingTable, &layout.handle, data, count, epsilon)
    }

    /// Swizzles an RGBA8 image to BGRA8
    ///
    /// - parameters:
    ///
    ///    - width: The width of the image
    ///    - height: The height of the image
    ///    - pitch: The pitch of the image in bytes
    ///    - source: The source image data
    ///    - dest: The destination image data
    ///
    /// - remark: This API can operate in the source data in place
    public static func imageSwizzleBGR8(_ width: UInt32, height: UInt32, pitch: UInt32, input source: [UInt32], dest: inout [UInt32]) {
        bgfx_image_swizzle_bgra8(width, height, pitch, source, &dest)
    }

    /// Downsamples an RGBA8 image with a 2x2 pixel average filter
    ///
    /// - parameters:
    ///
    ///    - width: The width of the image
    ///    - height: The height of the image
    ///    - pitch: The pitch of the image in bytes
    ///    - source: The source image data
    ///    - dest: The destination image data
    ///
    /// - remark: This API can operate in the source data in place
    public static func imageRGBADownsample2x2(_ width: UInt32, height: UInt32, pitch: UInt32, input source: [UInt32], dest: inout [UInt32]) {
        bgfx_image_rgba8_downsample_2x2(width, height, pitch, source, &dest)
    }

    /// Sets platform-specific data pointers to hook into low-level library functionality
    ///
    /// - parameter data: A collection of platform-specific data pointers
    ///
    /// - warning: Must be called before `initialize`
    public static func setPlatformData(_ data: PlatformData) {
        var data = data
        bgfx_set_platform_data(&data)
    }

    /// Sets platform-specific data pointers to hook into low-level library functionality
    ///
    /// - parameter data: A collection of platform-specific data pointers
    ///
    /// - warning: Must be called before `initialize`
    public static func setWindowHandle(_ handle: NativeWindowHandle) {
        var data = PlatformData()
        data.nwh = handle
        bgfx_set_platform_data(&data)
    }

    /// Provides access to bgfx internal data for interop scenarios
    ///
    /// - returns: A structure containing API context information
    public static func getInternalData() -> UnsafePointer<bgfx_internal_data_t> {
        return bgfx_get_internal_data()
    }

    /// Manually renders a frame. Use this to control the bgfx render loop
    ///
    /// - returns: The result of the render call
    ///
    /// - warning:
    /// This call should be only used on platforms that don’t allow creating
    /// separate rendering thread. If it is called before to `initialize`, render
    /// thread won’t be created by `initialize` call.
    public static func renderFrame() -> RenderFrameResult {
        let res = bgfx_render_frame()
        return RenderFrameResult(rawValue: res.rawValue)!
    }

    private static func toFloatPtr(_ v: UnsafeMutablePointer<Vector4f>) -> UnsafeMutablePointer<Float> {
        return unsafeBitCast(v, to: UnsafeMutablePointer<Float>.self)
    }
}
