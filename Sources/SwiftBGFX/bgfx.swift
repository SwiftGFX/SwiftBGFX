// Copyright 2016 Stuart Carnie.
// License: https://github.com/stuartcarnie/SwiftBGFX#license-bsd-2-clause
//

import Cbgfx

import SwiftMath

public class bgfx {
    
    /// The required API version of bgfx
    public static let APIVersion = 28

    /// Checks for available space to allocate transient index and vertex buffers
    ///
    /// - parameter vertexCount: The number of vertices to allocate
    /// - parameter layout: The layout of each vertex
    /// - parameter indexCount: The number of indices to allocate
    ///
    /// - returns: `true` if there is sufficient space for both vertex and index buffers
    public static func checkAvailableTransientBufferSpace(vertexCount: UInt32, layout: VertexLayout,
                                                          indexCount: UInt32) -> Bool {
        return bgfx_check_avail_transient_buffers(vertexCount, &layout.handle, indexCount)
    }

    /// Attempts to allocate both a transient vertex buffer and index buffer
    ///
    /// - parameter vertexCount: The number of vertices to allocate
    /// - parameter layout: The layout of each vertex
    /// - parameter indexCount: The number of indices to allocate
    /// - parameter vertexBuffer: Returns the allocated transient vertex buffer
    /// - parameter indexBuffer: Returns the allocated transient index buffer
    ///
    /// - returns: `true` if both space requirements are satisfied and the buffers were allocated
    @discardableResult
    public static func allocateTransientBuffers(vertexCount: UInt32, layout: VertexLayout, indexCount: UInt32,
                                                vertexBuffer: inout TransientVertexBuffer,
                                                indexBuffer: inout TransientIndexBuffer) -> Bool {
        return _allocateTransientBuffers(vertexCount, layout: layout, indexCount: indexCount,
                                         vertexBuffer: &vertexBuffer, indexBuffer: &indexBuffer)
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
    /// - parameter input: The four element vector to pack
    /// - parameter inputNormalized: `true` if the input vector is normalized
    /// - parameter attribute: The attribute usage of the vector data
    /// - parameter layout: The layout of the vertex stream
    /// - parameter data: The pointer to the vertex data stream
    /// - parameter index: The index of the vertex within the stream
    public static func vertexPack(input: Vector4f, inputNormalized: Bool, attribute: VertexAttributeUsage,
                                  layout: VertexLayout, data: UnsafeMutableRawPointer, index: UInt32 = 0) {
        typealias tuple = (CFloat, CFloat, CFloat, CFloat)
        var vec = unsafeBitCast(input, to: tuple.self)
        bgfx_vertex_pack(&vec.0, inputNormalized, bgfx_attrib_t(attribute.rawValue), &layout.handle, data, index)
    }

    /// Unpacks a vector from a vertex stream
    ///
    /// - parameter output: A pointer to four floats that will receive the unpacked vector
    /// - parameter attribute: The attribute usage of the vector data
    /// - parameter layout: The layout of the vertex stream
    /// - parameter data: The pointer to the vertex data stream
    /// - parameter index: The index of the vertex within the stream
    public static func vertexUnpack(output: inout Vector4f, attribute: VertexAttributeUsage,
                                  layout: VertexLayout, data: UnsafeMutableRawPointer, index: UInt32 = 0) {
        let vec = toFloatPtr(&output)
        bgfx_vertex_unpack(vec, bgfx_attrib_t(attribute.rawValue), &layout.handle, data, index)
    }

    /// Converts a stream of vertex data from one format to another
    ///
    /// - parameter destinationLayout: The destination vertext format
    /// - parameter destinationData: A pointer to the output location
    /// - parameter sourceLayout: The source vertext format
    /// - parameter sourceData: A pointer to the source data to convert
    /// - parameter count: The number of vertices to convert
    public static func vertexConvert(destinationLayout: VertexLayout, destinationData: UnsafeMutableRawPointer,
                                     sourceLayout: VertexLayout, sourceData: UnsafeMutableRawPointer,
                                     count: UInt32 = 1) {
        bgfx_vertex_convert(&destinationLayout.handle, destinationData, &sourceLayout.handle, sourceData, count);
    }

    /// Welds vertices that are close together
    ///
    /// - parameter layout: The layout of the vertex stream
    /// - parameter data: A pointer to the vertex data stream
    /// - parameter count: The number of vertices in the stream
    /// - parameter remappingTable: An output remapping table from the original vertices to the welded ones
    /// - parameter epsilon: The tolerance for welding vertex positions
    ///
    /// - returns: The number of unique vertices after welding
    @discardableResult
    public static func weldVertices(layout: VertexLayout, data: UnsafeMutableRawPointer, count: UInt16,
                                    remappingTable: inout [UInt16], epsilon: Float = 0.001) -> UInt16 {
        remappingTable = [UInt16](repeating: 0, count: Int(count))
        return bgfx_weld_vertices(&remappingTable, &layout.handle, data, count, epsilon)
    }

    /// Swizzles an RGBA8 image to BGRA8
    ///
    /// - parameter width: The width of the image
    /// - parameter height: The height of the image
    /// - parameter pitch: The pitch of the image in bytes
    /// - parameter source: The source image data
    /// - parameter dest: The destination image data
    ///
    /// - remark: This API can operate in the source data in place
    public static func imageSwizzleBGR8(width: UInt32, height: UInt32, pitch: UInt32, input source: [UInt32],
                                        dest: inout [UInt32]) {
        bgfx_image_swizzle_bgra8(width, height, pitch, source, &dest)
    }

    /// Downsamples an RGBA8 image with a 2x2 pixel average filter
    ///
    /// - parameter width: The width of the image
    /// - parameter height: The height of the image
    /// - parameter pitch: The pitch of the image in bytes
    /// - parameter source: The source image data
    /// - parameter dest: The destination image data
    ///
    /// - remark: This API can operate in the source data in place
    public static func imageRGBADownsample2x2(width: UInt32, height: UInt32, pitch: UInt32, input source: [UInt32],
                                              dest: inout [UInt32]) {
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
    @discardableResult
    public static func renderFrame() -> RenderFrameResult {
        let res = bgfx_render_frame()
        return RenderFrameResult(rawValue: res.rawValue)!
    }

    private static func toFloatPtr(_ v: UnsafeMutablePointer<Vector4f>) -> UnsafeMutablePointer<Float> {
        return unsafeBitCast(v, to: UnsafeMutablePointer<Float>.self)
    }
}
