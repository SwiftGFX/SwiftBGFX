// Copyright 2016 Stuart Carnie.
// License: https://github.com/stuartcarnie/SwiftBGFX#license-bsd-2-clause
//

import Cbgfx

import SwiftMath

extension bgfx {

    // MARK: - Initialization and shutdown

    ///
    /// Initialize the SwiftBGFX library
    ///
    /// - parameter type: Select rendering backend. When set to `RendererBackend.Default`,
    ///     default rendering backend will be selected.
    ///
    /// - returns: `true` if initialization was successful
    ///
    @discardableResult
    public static func initialize(type: RendererBackend = .best, vendorId: VendorID = .none, callback: Callbacks? = nil) -> Bool {
        var cbi: UnsafeMutablePointer<bgfx_callback_interface_t>?
        if let cb = callback {
            cbi = makeCallbackHandler(cb)
        }

        //var cbi = makeCallbackHandler(callback)
        return bgfx_init(bgfx_renderer_type_t(type.rawValue), 0, 0, cbi != nil ? cbi! : nil, nil)
    }

    /// Shutdown the SwiftBGFX library
    public static func shutdown() {
        bgfx_shutdown()
    }

    // MARK: - Updating

    ///
    /// Reset graphic settings and back-buffer size
    ///
    /// - parameter width: Back-buffer width
    /// - parameter height: Back-buffer height
    /// - parameter options: See `ResetOptions`
    ///
    public static func reset(width: UInt16, height: UInt16, options: ResetOptions) {
        bgfx_reset(UInt32(width), UInt32(height), options.rawValue)
    }

    /// Advance to next frame. When using the multithreaded renderer, this call just
    /// swaps internal buffers, kicks render thread, and returns. In singlethreaded
    /// renderer this call does frame rendering.
    ///
    /// - parameter capture: `true` to capture the frame
    ///
    /// - returns:
    /// Current frame number. This might be used in conjunction with double/multi
    /// buffering data outside the library and passing it to library via
    /// `bgfx::makeRef` calls.
    @discardableResult
    public static func frame(capture: Bool = false) -> UInt32 {
        return bgfx_frame(capture)
    }

    // MARK: - Debug

    /// Set debug options
    public static var debug: DebugOptions = DebugOptions.none {
        willSet(newOptions) {
            bgfx_set_debug(newOptions.rawValue)
        }
    }

    public static func debugTextClear(color: DebugColor = .transparent, small: Bool = false) {
        bgfx_dbg_text_clear(color.rawValue << 4, small)
    }

    public static func debugTextPrint(x: UInt16, y: UInt16, foreColor: DebugColor, backColor: DebugColor, format: String, _ arguments: CVarArg...) {
        // retain references to array for vprintf call
        var objs: [ContiguousArray<CChar>] = []
        
        let args: [CVarArg] = arguments.map {
            if let s = $0 as? String {
                let utf = s.utf8CString
                objs.append(utf)
                return utf.withUnsafeBufferPointer {
                    return $0.baseAddress!
                }
            }
            return $0
        }
        
        withVaList(args) {
            bgfx_dbg_text_vprintf(x, y, (backColor.rawValue << 4) | foreColor.rawValue, format, $0)
        }
    }
    
    public static func debugTextImage(x: UInt16, y: UInt16, width: UInt16, height: UInt16, data: [UInt8], pitch: UInt16) {
        bgfx_dbg_text_image(x, y, width, height, data, pitch)
    }

    // MARK: - Renderer

    /// Returns current renderer backend API type
    public static var rendererType: RendererBackend {
        return RendererBackend(rawValue: bgfx_get_renderer_type().rawValue)!
    }

    /// Returns renderer capabilities
    public static var capabilities: Capabilities {
        return Capabilities(caps: bgfx_get_caps())
    }

    public static var stats: Stats {
        return unsafeBitCast(bgfx_get_stats().pointee, to: Stats.self)
    }

    // MARK: - Head Mounted Display

    // TODO head mounted display APIs

    // MARK: - Platform Specific

    /// Set palette color value
    ///
    /// - parameter index: Index into palette
    /// - parameter r: red color value
    /// - parameter g: green color value
    /// - parameter b: blue color value
    /// - parameter a: alpha color value
    public static func setPaletteColor(index: UInt8, r: Float, g: Float, b: Float, a: Float) {
        var rgba = (r, g, b, a)
        bgfx_set_palette_color(index, &rgba.0)
    }

    // MARK: - Views

    /// Set view name
    ///
    /// In graphics debugger view name will appear as:
    ///
    ///     "nnnce <view name>"
    ///      ^  ^^ ^
    ///      |  |+-- eye (L/R)
    ///      |  +--- compute (C)
    ///      +------ view id
    ///
    /// - remark: This is debug only feature
    ///
    public static func setViewName(viewId: UInt8, name: String) {
        bgfx_set_view_name(viewId, name)
    }

    /// Set view rectangle. Draw primitive outside view will be clipped
    ///
    /// - parameter viewId: View id
    /// - parameter x: Position x from the left corner of the window
    /// - parameter y: Position y from the top corner of the window
    /// - parameter width: Width of the viewport region
    /// - parameter height: Height of the viewport region
    public static func setViewRect(viewId: UInt8, x: UInt16, y: UInt16, width: UInt16, height: UInt16) {
        bgfx_set_view_rect(viewId, x, y, width, height)
    }

    /// Set view rectangle. Draw primitive outside view will be clipped
    ///
    /// - parameter viewId: View id
    /// - parameter x: Position x from the left corner of the window
    /// - parameter y: Position y from the top corner of the window
    /// - parameter ratio: Backbuffer ratio
    ///
    public static func setViewRect(viewId: UInt8, x: UInt16, y: UInt16, ratio: BackbufferRatio) {
        bgfx_set_view_rect_auto(viewId, x, y, bgfx_backbuffer_ratio_t(ratio.rawValue))
    }

    /// Set view scissor. Draw primitive outside view will be clipped.
    /// When x, y, width and height are set to 0, scissor will be disabled
    ///
    ///  - parameter viewId: View id
    ///  - parameter x: Position x from the left corner of the window
    ///  - parameter y: Position y from the top corner of the window
    ///  - parameter width: Width of the viewport region
    ///  - parameter height: Height of the viewport region
    public static func setViewScissor(viewId: UInt8, x: UInt16, y: UInt16, width: UInt16, height: UInt16) {
        bgfx_set_view_scissor(viewId, x, y, width, height)
    }

    /// Set view clear options
    ///
    /// - parameter viewId: View id
    /// - parameter options: Clear options. Use `ClearOptions.none` to remove any clear operation
    /// - parameter rgba: Color clear value
    /// - parameter depth: Depth clear value
    /// - parameter stencil: Stencil clear value
    ///
    public static func setViewClear(viewId: UInt8, options: ClearOptions, rgba: UInt32, depth: Float, stencil: UInt8) {
        bgfx_set_view_clear(viewId, options.rawValue, rgba, depth, stencil)
    }

    /// Set view clear options, with a different color for each frame buffer texture.
    ///
    /// - parameter viewId: View id
    /// - parameter options: Clear options. Use `ClearOptions.none` to remove any clear operation
    /// - parameter rgba: Color clear value
    /// - parameter depth: Depth clear value
    /// - parameter stencil: Stencil clear value
    /// - parameter b0: palette index for frame buffer 0
    /// - parameter b1: palette index for frame buffer 1
    /// - parameter b2: palette index for frame buffer 2
    /// - parameter b3: palette index for frame buffer 3
    /// - parameter b4: palette index for frame buffer 4
    /// - parameter b5: palette index for frame buffer 5
    /// - parameter b6: palette index for frame buffer 6
    /// - parameter b7: palette index for frame buffer 7
    ///
    /// - remark: use `setPaletteColor` to configure colors for each palette index
    ///
    public static func setViewClear(viewId: UInt8, options: ClearOptions, depth: Float, stencil: UInt8,
                                    b0: UInt8 = UInt8.max, b1: UInt8 = UInt8.max,
                                    b2: UInt8 = UInt8.max, b3: UInt8 = UInt8.max,
                                    b4: UInt8 = UInt8.max, b5: UInt8 = UInt8.max,
                                    b6: UInt8 = UInt8.max, b7: UInt8 = UInt8.max) {
        bgfx_set_view_clear_mrt(viewId, options.rawValue, depth, stencil,
                b0, b1, b2, b3, b4, b5, b6, b7)
    }

    /// Set view into sequential mode. Draw calls will be sorted in the same order
    /// in which submit calls were called
    ///
    /// - parameter viewId: View id
    /// - parameter enabled: `true` to enable sequential mode
    public static func setViewSequential(viewId: UInt8, enabled: Bool) {
        bgfx_set_view_seq(viewId, enabled)
    }

    /// Set view view and projection matrices, all draw primitives in this view
    /// will use these matrices.
    ///
    /// - parameter viewId: View id
    /// - parameter view: View matrix
    /// - parameter proj: Projection matrix
    public static func setViewTransform(viewId: UInt8, view: Matrix4x4f, proj: Matrix4x4f) {
        var v = view
        var p = proj
        bgfx_set_view_transform(viewId, &v, &p)
    }

    /// Set view view and projection matrices, all draw primitives in this view
    /// will use these matrices.
    ///
    /// - parameter viewId: View id
    /// - parameter proj: Projection matrix
    public static func setViewTransform(viewId: UInt8, proj: Matrix4x4f) {
        var p = proj
        bgfx_set_view_transform(viewId, nil, &p)
    }

    /// Set view view and projection matrices, all draw primitives in this view
    /// will use these matrices.
    ///
    /// - parameter viewId: View id
    /// - parameter view: View matrix
    /// - parameter proj: Projection matrix
    public static func setViewTransform(viewId: UInt8, view: [Float], proj: [Float]) {
        var v = view
        var p = proj
        bgfx_set_view_transform(viewId, &v, &p)
    }

    /// Set view frame buffer
    ///
    /// - parameter viewId: View id
    /// - parameter buffer: Frame buffer. Passing `FrameBuffer.InvalidHandle` will draw
    ///     primitives from this view into default back buffer
    ///
    /// - remark: Not persistent after `reset`
    ///
    public static func setViewFrameBuffer(viewId: UInt8, buffer: FrameBuffer) {
        bgfx_set_view_frame_buffer(viewId, buffer.handle)
    }

    // MARK: - Draw

    // MARK: Draw State

    /// Sets a marker that can be used for debugging purposes
    ///
    /// - parameter name: The user-defined name of the marker
    public static func setDebugMarker(name: String) {
        bgfx_set_marker(name)
    }

    // MARK: Draw Scissor

    /// Set scissor for draw primitive.
    ///
    /// - returns: Scissor cache index
    ///
    /// - remark: to set the scissor for all primitives in view see `bgfx.setViewScissor`
    public static func setScissor(x: UInt16, y: UInt16, width: UInt16, height: UInt16) -> UInt16 {
        return bgfx_set_scissor(x, y, width, height)
    }

    /// Set scissor from cache for draw primitive.
    ///
    /// - parameter cache: Index in scissor cache. Passing `UInt16.max` will unset
    ///        primitive scissor and primitive will use view scissor instead.
    ///
    /// - returns: Scissor cache index
    ///
    /// - remark: to set the scissor for all primitives in view see `bgfx.setViewScissor`
    public static func setScissor(cache: UInt16) {
        bgfx_set_scissor_cached(cache)
    }

    // MARK: Draw Transform

    /// Set model matrix for draw primitive. If it is not called model will be
    /// rendered with identity model matrix
    ///
    /// - returns: index into matrix cache in case the same model matrix has to be
    ///            used for additional draw primitive calls
    ///
    @discardableResult
    public static func setTransform(_ matrix: Matrix4x4f) -> UInt32 {
        var mtx = matrix
        return bgfx_set_transform(&mtx, 1)
    }

    public static func setTransform(_ matrix: [Float]) -> UInt32 {
        return bgfx_set_transform(matrix, 1)
    }

    /// Set model matrix from matrix cache for draw primitive
    ///
    /// - parameter cache: index in matrix cache
    /// - parameter num: number of matrices from cache
    public static func setTransform(_ cache: UInt32, num: UInt16) {
        bgfx_set_transform_cached(cache, num)
    }

    // MARK: Conditional Rendering

    // MARK: Draw Buffers

    /// Sets the index buffer to use for drawing primitives
    ///
    /// - parameter buf: Index buffer
    public static func setIndexBuffer(_ buf: IndexBuffer) {
        bgfx_set_index_buffer(buf.handle, 0, UInt32.max)
    }

    /// Sets the index buffer to use for drawing primitives
    ///
    /// - parameter buf: Index buffer
    /// - parameter firstIndex: First index to render
    /// - parameter count: Number of indices to render
    public static func setIndexBuffer(_ buf: IndexBuffer, firstIndex: UInt32, count: UInt32) {
        bgfx_set_index_buffer(buf.handle, firstIndex, count)
    }

    /// Sets the index buffer to use for drawing primitives
    ///
    /// - parameter buf: Dynamic index buffer
    public static func setIndexBuffer(_ buf: DynamicIndexBuffer) {
        bgfx_set_dynamic_index_buffer(buf.handle, 0, UInt32.max)
    }

    /// Sets the index buffer to use for drawing primitives
    ///
    /// - parameter buf: Dynamic index buffer
    /// - parameter firstIndex: First index to render
    /// - parameter count: Number of indices to render
    public static func setIndexBuffer(_ buf: DynamicIndexBuffer, firstIndex: UInt32, count: UInt32) {
        bgfx_set_dynamic_index_buffer(buf.handle, firstIndex, count)
    }

    /// Sets the index buffer to use for drawing primitives
    ///
    /// - parameter buf: Transient index buffer
    public static func setIndexBuffer(_ buf: TransientIndexBuffer) {
        var d = unsafeBitCast(buf.buffer, to: bgfx_transient_index_buffer.self)
        bgfx_set_transient_index_buffer(&d, 0, UInt32.max)
    }

    /// Sets the index buffer to use for drawing primitives
    ///
    /// - parameter buf: Transient index buffer
    /// - parameter firstIndex: First index to render
    /// - parameter count: Number of indices to render
    public static func setIndexBuffer(_ buf: TransientIndexBuffer, firstIndex: UInt32, count: UInt32) {
        var d = unsafeBitCast(buf.buffer, to: bgfx_transient_index_buffer.self)
        bgfx_set_transient_index_buffer(&d, firstIndex, count)
    }


    /// Sets the vertex buffer to use for drawing primitives
    ///
    /// - parameter buf: Vertex buffer
    public static func setVertexBuffer(_ buf: VertexBuffer) {
        bgfx_set_vertex_buffer(buf.handle, 0, UInt32.max)
    }

    /// Sets the vertex buffer to use for drawing primitives
    ///
    /// - parameter buf: Vertex buffer
    /// - parameter firstVertex: First vertex to render
    /// - parameter count: Number of indices to render
    public static func setVertexBuffer(_ buf: VertexBuffer, firstVertex: UInt32, count: UInt32) {
        bgfx_set_vertex_buffer(buf.handle, firstVertex, count)
    }

    /// Sets the vertex buffer to use for drawing primitives
    ///
    /// - parameter buf: Dynamic vertex buffer
    public static func setVertexBuffer(_ buf: DynamicVertexBuffer) {
        bgfx_set_dynamic_vertex_buffer(buf.handle, 0, UInt32.max)
    }

    /// Sets the vertex buffer to use for drawing primitives
    ///
    /// - parameter buf: Dynamic vertex buffer
    /// - parameter firstVertex: First vertex to render
    /// - parameter count: Number of indices to render
    public static func setVertexBuffer(_ buf: DynamicVertexBuffer, firstVertex: UInt32, count: UInt32) {
        bgfx_set_dynamic_vertex_buffer(buf.handle, firstVertex, count)
    }

    /// Sets the vertex buffer to use for drawing primitives
    ///
    /// - parameter buf: Transient vertex buffer
    public static func setVertexBuffer(_ buf: TransientVertexBuffer) {
        var d = unsafeBitCast(buf.buffer, to: bgfx_transient_vertex_buffer.self)
        bgfx_set_transient_vertex_buffer(&d, 0, UInt32.max)
    }

    /// Sets the vertex buffer to use for drawing primitives
    ///
    /// - parameter buf: Transient vertex buffer
    /// - parameter firstVertex: First vertex to render
    /// - parameter count: Number of indices to render
    public static func setVertexBuffer(_ buf: TransientVertexBuffer, firstVertex: UInt32, count: UInt32) {
        var d = unsafeBitCast(buf.buffer, to: bgfx_transient_vertex_buffer.self)
        bgfx_set_transient_vertex_buffer(&d, firstVertex, count)
    }

    /// Sets instance data to use for drawing primitives
    ///
    /// - parameter buf: The instance data
    /// - parameter count: The number of entries to pull from the buffer
    public static func setInstanceDataBuffer(_ buf: InstanceDataBuffer, count: UInt32 = UInt32.max) {
        bgfx_set_instance_data_buffer(buf.handle, count)
    }

    /// Sets instance data to use for drawing primitives
    ///
    /// - parameter buf: The instance data
    /// - parameter firstVertex: First vertex to render
    /// - parameter count: The number of entries to pull from the buffer
    public static func setInstanceDataBuffer(_ buf: VertexBuffer, firstVertex: UInt32, count: UInt32) {
        bgfx_set_instance_data_from_vertex_buffer(buf.handle, firstVertex, count)
    }

    /// Sets instance data to use for drawing primitives
    ///
    /// - parameter buf: The instance data
    /// - parameter firstVertex: First vertex to render
    /// - parameter count: The number of entries to pull from the buffer
    public static func setInstanceDataBuffer(_ buf: DynamicVertexBuffer, firstVertex: UInt32, count: UInt32) {
        bgfx_set_instance_data_from_dynamic_vertex_buffer(buf.handle, firstVertex, count)
    }

    /// Sets the value of a uniform parameter
    public static func setUniform(_ uniform: Uniform, value: Vector4f) {
        var ptr = value
        bgfx_set_uniform(uniform.handle, &ptr, 1)
    }

    /// Sets the value of a uniform parameter
    public static func setUniform(_ uniform: Uniform, value: Matrix4x4f) {
        var ptr = value
        bgfx_set_uniform(uniform.handle, &ptr, 1)
    }

    /// Sets a texture to use for drawing primitives
    ///
    /// - parameter unit: The texture unit to set
    /// - parameter sampler: The sampler uniform
    /// - parameter texture: The texture to set
    /// - parameter options: Sampling options that override the default options in the texture itself
    public static func setTexture(_ unit: UInt8, sampler: Uniform, texture: Texture,
                                  options: TextureOptions = [.`default`]) {
        bgfx_set_texture(unit, sampler.handle, texture.handle, options.rawValue)
    }

    /// Sets a texture to use for drawing primitives
    ///
    /// - parameter unit: The texture unit to set
    /// - parameter sampler: The sampler uniform
    /// - parameter frameBuffer: The frame buffer
    /// - parameter attachment: The index of the attachment to set
    /// - parameter options: Sampling options that override the default options in the texture itself
    public static func setTexture(_ unit: UInt8, sampler: Uniform, frameBuffer: FrameBuffer, attachment: UInt8 = 0,
                                  options: TextureOptions = [.`default`]) {
        bgfx_set_texture_from_frame_buffer(unit, sampler.handle, frameBuffer.handle, attachment, options.rawValue)
    }

    /// Sets a texture mip as a compute image
    ///
    /// - parameter stage: The buffer stage to set
    /// - parameter sampler: The sampler uniform
    /// - parameter texture: The texture to set
    /// - parameter mip: The index of the mip level within the texture to set
    /// - parameter access: Access control mode
    /// - parameter format: The format of the buffer data
    public static func setComputeImage(_ stage: UInt8, sampler: Uniform, texture: Texture, mip: UInt8,
                                       access: ComputeBufferAccess, format: TextureFormat = .unknown) {
        bgfx_set_image(stage, sampler.handle, texture.handle, mip, bgfx_access_t(access.rawValue),
                       bgfx_texture_format_t(format.rawValue))
    }

    /// Sets a frame buffer attachment as a compute image
    ///
    /// - parameter stage: The buffer stage to set
    /// - parameter sampler: The sampler uniform
    /// - parameter frameBuffer: The frame buffer
    /// - parameter attachment: The attachment index
    /// - parameter access: Access control mode
    /// - parameter format: The format of the buffer data
    public static func setComputeImage(_ stage: UInt8, sampler: Uniform, frameBuffer: FrameBuffer, attachment: UInt8,
                                       access: ComputeBufferAccess, format: TextureFormat = .unknown) {
        bgfx_set_image_from_frame_buffer(stage, sampler.handle, frameBuffer.handle, attachment,
                                         bgfx_access_t(access.rawValue), bgfx_texture_format_t(format.rawValue))
    }

    /// Sets an index buffer as a compute resource
    ///
    /// - parameter stage: The buffer stage to set
    /// - parameter buffer: The buffer to set
    /// - parameter access: Access control mode
    public static func setComputeBuffer(_ stage: UInt8, buffer: IndexBuffer, access: ComputeBufferAccess) {
        bgfx_set_compute_index_buffer(stage, buffer.handle, bgfx_access_t(access.rawValue))
    }

    /// Sets a vertex buffer as a compute resource
    ///
    /// - parameter stage: The buffer stage to set
    /// - parameter buffer: The buffer to set
    /// - parameter access: Access control mode
    public static func setComputeBuffer(_ stage: UInt8, buffer: VertexBuffer, access: ComputeBufferAccess) {
        bgfx_set_compute_vertex_buffer(stage, buffer.handle, bgfx_access_t(access.rawValue))
    }

    /// Sets a dynamic index buffer as a compute resource
    ///
    /// - parameter stage: The buffer stage to set
    /// - parameter buffer: The buffer to set
    /// - parameter access: Access control mode
    public static func setComputeBuffer(_ stage: UInt8, buffer: DynamicIndexBuffer, access: ComputeBufferAccess) {
        bgfx_set_compute_dynamic_index_buffer(stage, buffer.handle, bgfx_access_t(access.rawValue))
    }

    /// Sets a dynamic vertex buffer as a compute resource
    ///
    /// - parameter stage: The buffer stage to set
    /// - parameter buffer: The buffer to set
    /// - parameter access: Access control mode
    public static func setComputeBuffer(_ stage: UInt8, buffer: DynamicVertexBuffer, access: ComputeBufferAccess) {
        bgfx_set_compute_dynamic_vertex_buffer(stage, buffer.handle, bgfx_access_t(access.rawValue))
    }

    /// Sets an indirect buffer as a compute resource
    ///
    /// - parameter stage: The buffer stage to set
    /// - parameter buffer: The buffer to set
    /// - parameter access: Access control mode
    public static func setComputeBuffer(_ stage: UInt8, buffer: IndirectBuffer, access: ComputeBufferAccess) {
        bgfx_set_compute_indirect_buffer(stage, buffer.handle, bgfx_access_t(access.rawValue))
    }

    /// Submit an empty primitive for rendering. Uniforms and draw state will be
    /// applied but no geometry will be submitted.
    ///
    /// These empty draw calls will sort before ordinary draw calls.
    ///
    /// - parameter viewId: the view ID
    ///
    /// - returns: Number of draw calls
    @discardableResult
    public static func touch(_ viewId: UInt8) -> UInt32 {
        return bgfx_touch(viewId)
    }

    /// Resets all view settings to default
    public static func resetView(_ viewId: UInt8) {
        bgfx_reset_view(viewId)
    }

    /// Submits the current batch of primitives for rendering
    ///
    /// - parameter viewId: The index of the view to submit
    /// - parameter program: The program with which to render
    /// - parameter depth: A depth value to use for sorting the batch
    /// - parameter preserveState: `true` to preserve internal draw state after the call
    ///
    /// - returns: Number of draw calls
    @discardableResult
    public static func submit(_ viewId: UInt8, program: Program, depth: Int32 = 0, preserveState: Bool = false) -> UInt32 {
        return bgfx_submit(viewId, program.handle, depth, preserveState)
    }

    /// Submits the current batch of primitives for rendering
    ///
    /// - parameter viewId: The index of the view to submit
    /// - parameter program: The program with which to render
    /// - parameter query: An occlusion query to use as a predicate during rendering
    /// - parameter depth: A depth value to use for sorting the batch
    /// - parameter preserveState: `true` to preserve internal draw state after the call
    ///
    /// - returns: Number of draw calls
    @discardableResult
    public static func submit(_ viewId: UInt8, program: Program, query: OcclusionQuery, depth: Int32 = 0, preserveState: Bool = false) -> UInt32 {
        return bgfx_submit_occlusion_query(viewId, program.handle, query.handle, depth, preserveState)
    }

    /// Submits an indirect batch of drawing commands to be used for rendering
    ///
    /// - parameter viewId: The index of the view to submit
    /// - parameter program: The program with which to render
    /// - parameter indirectBuffer: The buffer containing drawing commands
    /// - parameter startIndex: The index of the first command to process
    /// - parameter count: The number of commands to process from the buffer
    /// - parameter depth: A depth value to use for sorting the batch
    /// - parameter preserveState: `true` to preserve internal draw state after the call
    ///
    /// - returns: Number of draw calls
    @discardableResult
    public static func submit(_ viewId: UInt8, program: Program, indirectBuffer: IndirectBuffer, startIndex: UInt16 = 0, count: UInt16 = 1, depth: Int32 = 0, preserveState: Bool = false) -> UInt32 {
        return bgfx_submit_indirect(viewId, program.handle, indirectBuffer.handle, startIndex, count, depth, preserveState)
    }

    /// Discard all previously set state for draw or compute call
    public static func discard() {
        bgfx_discard()
    }

    /// Dispatches a compute job
    ///
    /// - parameter viewId: The index of the view to dispatch
    /// - parameter program: The shader program to use
    /// - parameter xCount: The size of the job in the first dimension
    /// - parameter yCount: The size of the job in the second dimension
    /// - parameter zCount: The size of the job in the third dimension
    public static func dispatch(_ viewId: UInt8, program: Program, xCount: UInt16 = 1, yCount: UInt16 = 1, zCount: UInt16 = 1) {
        bgfx_dispatch(viewId, program.handle, xCount, yCount, zCount, 0)
    }

    /// Dispatches an indirect compute job
    ///
    /// - parameter viewId: The index of the view to dispatch
    /// - parameter program: The shader program to use
    /// - parameter buffer: The buffer containing drawing commands
    /// - parameter xCount: The size of the job in the first dimension
    /// - parameter yCount: The size of the job in the second dimension
    /// - parameter zCount: The size of the job in the third dimension
    public static func dispatch(_ viewId: UInt8, program: Program, buffer: IndirectBuffer, startIndex: UInt16 = 1, count: UInt16 = 1, zCount: UInt16 = 1) {
        bgfx_dispatch_indirect(viewId, program.handle, buffer.handle, startIndex, count, 0)
    }

    /// Requests that a screenshot be saved. The ScreenshotTaken event will be fired to save the result
    ///
    /// - parameter filePath: The file path that will be passed to the callback event
    public static func saveScreenShot(path: String) {
        bgfx_save_screen_shot(path)
    }

    /// Set rendering states used to draw primitives
    ///
    /// - parameter state: The set of states to set
    /// - parameter colorRgba: The color used for "factor" blending modes
    public static func setRenderState(_ state: RenderStateOptions, colorRgba: UInt32) {
        bgfx_set_state(state.rawValue, colorRgba)
    }

    /// Sets stencil test state
    ///
    /// - parameter frontFace: The stencil state to use for front faces
    public static func setStencil(_ frontFace: StencilOptions) {
        bgfx_set_stencil(frontFace.rawValue, StencilOptions.none.rawValue)
    }

    /// Sets stencil test state
    ///
    /// - parameter frontFace: The stencil state to use for front faces
    /// - parameter backFace: The stencil state to use for back faces
    public static func setStencil(_ frontFace: StencilOptions, backFace: StencilOptions) {
        bgfx_set_stencil(frontFace.rawValue, backFace.rawValue)
    }
}
