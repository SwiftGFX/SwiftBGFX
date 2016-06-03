//
//  bgfx.swift
//  bgfx Test
//
//  Created by Stuart Carnie on 4/16/16.
//  Copyright © 2016 SGC. All rights reserved.
//

import simd

extension bgfx {

    // MARK:- Initialization and shutdown

    ///
    /// Initialize bgfx library
    ///
    /// - parameters:
    ///
    ///     - type: Select rendering backend. When set to `RendererBackend.Default`,
    /// default rendering backend will be selected.
    ///
    /// - Returns: `true` if initialization was successful
    ///
    public static func initialize(type type: RendererBackend = .Default, vendorId: VendorID = .None, callback: Callbacks? = nil) -> Bool {
        var cbi: UnsafeMutablePointer<bgfx_callback_interface_t>?
        if let cb = callback {
            cbi = makeCallbackHandler(cb)
        }
        
        //var cbi = makeCallbackHandler(callback)
        return bgfx_init(bgfx_renderer_type_t(type.rawValue), 0, 0, cbi != nil ? cbi! : nil, nil)
    }

    /// Shutdown bgfx library
    public static func shutdown() {
        bgfx_shutdown()
    }

    // MARK:- Updating

    ///
    /// Reset graphic settings and back-buffer size
    ///
    /// - parameters:
    ///
    ///     - width: Back-buffer width
    ///     - height: Back-buffer height
    ///     - options: See `ResetOptions`
    ///
    public static func reset(width width: UInt16, height: UInt16, options: ResetOptions) {
        bgfx_reset(UInt32(width), UInt32(height), options.rawValue)
    }

    /// Advance to next frame. When using the multithreaded renderer, this call just
    /// swaps internal buffers, kicks render thread, and returns. In singlethreaded
    /// renderer this call does frame rendering.
    ///
    /// - parameters:
    ///     
    ///     - capture: `true` to capture the frame
    ///
    /// - returns:
    /// Current frame number. This might be used in conjunction with double/multi
    /// buffering data outside the library and passing it to library via
    /// `bgfx::makeRef` calls.
    public static func frame(capture: Bool = false) -> UInt32 {
        return bgfx_frame(capture)
    }

    // MARK:- Debug

    /// Set debug options
    public static var debug: DebugOptions = DebugOptions.None {
        willSet(newOptions) {
            bgfx_set_debug(newOptions.rawValue)
        }
    }

    public static func debugTextClear(color: DebugColor = .Transparent, small: Bool = false) {
        bgfx_dbg_text_clear(color.rawValue << 4, small)
    }

    public static func debugTextPrint(x x: UInt16, y: UInt16, foreColor: DebugColor, backColor: DebugColor, string: String) {
        bgfx_dbg_text_print(x, y, (backColor.rawValue << 4) | foreColor.rawValue, string)
    }

    public static func debugTextImage(x x: UInt16, y: UInt16, width: UInt16, height: UInt16, data: [UInt8], pitch: UInt16) {
        bgfx_dbg_text_image(x, y, width, height, data, pitch)
    }

    // MARK:- Renderer

    /// Returns current renderer backend API type
    public static var rendererType: RendererBackend {
        return RendererBackend(rawValue: bgfx_get_renderer_type().rawValue)!
    }

    /// Returns renderer capabilities
    public static var capabilities: Capabilities {
        return Capabilities(caps: bgfx_get_caps())
    }

    public static var stats: Stats {
        return unsafeBitCast(bgfx_get_stats().memory, Stats.self)
    }

    // MARK:- Head Mounted Display

    // TODO head mounted display APIs

    // MARK:- Platform Specific

    /// Set palette color value
    ///
    /// - Parameters:
    ///
    ///     - index: Index into palette
    ///     - r: red color value
    ///     - g: green color value
    ///     - b: blue color value
    ///     - a: alpha color value
    public static func setPaletteColor(index: UInt8, r: Float, g: Float, b: Float, a: Float) {
        var rgba = (r, g, b, a)
        bgfx_set_palette_color(index, &rgba.0)
    }

    // MARK:- Views

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
    /// - Parameters:
    ///
    ///     - viewId: View id
    ///     - x: Position x from the left corner of the window
    ///     - y: Position y from the top corner of the window
    ///     - width: Width of the viewport region
    ///     - height: Height of the viewport region
    public static func setViewRect(viewId: UInt8, x: UInt16, y: UInt16, width: UInt16, height: UInt16) {
        bgfx_set_view_rect(viewId, x, y, width, height)
    }

    /// Set view rectangle. Draw primitive outside view will be clipped
    ///
    /// - Parameters:
    ///
    ///     - viewId: View id
    ///     - x: Position x from the left corner of the window
    ///     - y: Position y from the top corner of the window
    ///     - ratio: Backbuffer ratio
    ///
    public static func setViewRect(viewId: UInt8, x: UInt16, y: UInt16, ratio: BackbufferRatio) {
        bgfx_set_view_rect_auto(viewId, x, y, bgfx_backbuffer_ratio_t(ratio.rawValue))
    }

    /// Set view scissor. Draw primitive outside view will be clipped.
    /// When x, y, width and height are set to 0, scissor will be disabled
    ///
    /// - Parameters:
    ///
    ///     - viewId: View id
    ///     - x: Position x from the left corner of the window
    ///     - y: Position y from the top corner of the window
    ///     - width: Width of the viewport region
    ///     - height: Height of the viewport region
    public static func setViewScissor(viewId: UInt8, x: UInt16, y: UInt16, width: UInt16, height: UInt16) {
        bgfx_set_view_scissor(viewId, x, y, width, height)
    }

    /// Set view clear flags
    ///
    /// - Parameters:
    ///
    ///     - viewId: View id
    ///     - options: Clear options. Use `ClearTargets.None` to remove any clear
    ///                operation
    ///     - rgba: Color clear value
    ///     - depth: Depth clear value
    ///     - stencil: Stencil clear value
    ///
    public static func setViewClear(viewId: UInt8, options: ClearTargets, rgba: UInt32, depth: Float, stencil: UInt8) {
        bgfx_set_view_clear(viewId, options.rawValue, rgba, depth, stencil)
    }

    /// Set view clear flags
    ///
    /// - Parameters:
    ///
    ///     - viewId: View id
    ///     - options: Clear options. Use `ClearTargets.None` to remove any clear
    ///                operation
    ///     - rgba: Color clear value
    ///     - depth: Depth clear value
    ///     - stencil: Stencil clear value
    ///
    public static func setViewClear(viewId: UInt8, options: ClearTargets, depth: Float, stencil: UInt8,
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
    /// - Parameters:
    ///
    ///     - viewId: View id
    ///     - enabled: `true` to enable sequential mode
    public static func setViewSequential(viewId: UInt8, enabled: Bool) {
        bgfx_set_view_seq(viewId, enabled)
    }

    /// Set view view and projection matrices, all draw primitives in this view
    /// will use these matrices.
    ///
    /// - Parameters:
    ///
    ///     - viewId: View id
    ///     - view: View matrix
    ///     - proj: Projection matrix
    public static func setViewTransform(viewId: UInt8, view: float4x4, proj: float4x4) {
        var v = view
        var p = proj
        bgfx_set_view_transform(viewId, &v, &p)
    }

    /// Set view view and projection matrices, all draw primitives in this view
    /// will use these matrices.
    ///
    /// - Parameters:
    ///
    ///     - viewId: View id
    ///     - proj: Projection matrix
    public static func setViewTransform(viewId: UInt8, proj: float4x4) {
        var p = proj
        bgfx_set_view_transform(viewId, nil, &p)
    }

    /// Set view view and projection matrices, all draw primitives in this view
    /// will use these matrices.
    ///
    /// - Parameters:
    ///
    ///     - viewId: View id
    ///     - view: View matrix
    ///     - proj: Projection matrix
    public static func setViewTransform(viewId: UInt8, view: [Float], proj: [Float]) {
        var v = view
        var p = proj
        bgfx_set_view_transform(viewId, &v, &p)
    }
    
    /// Set view frame buffer
    ///
    /// - Parameters:
    ///
    ///     - viewId: View id
    ///     - buffer: Frame buffer. Passing `FrameBuffer.InvalidHandle` will draw
    ///               primitives from this view into default back buffer
    ///
    /// - Remark: Not persistent after `reset`
    ///
    public static func setViewFrameBuffer(viewId: UInt8, buffer: FrameBuffer) {
        bgfx_set_view_frame_buffer(viewId, buffer.handle)
    }

    // MARK:- Draw

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
    public static func setTransform(matrix: [float4x4]) -> UInt32 {
        return bgfx_set_transform(matrix, UInt16(matrix.count))
    }
    
    public static func setTransform(matrix: [Float]) -> UInt32 {
        return bgfx_set_transform(matrix, 1)
    }

    /// Set model matrix from matrix cache for draw primitive
    ///
    /// - parameters:
    ///
    ///    - cache: index in matrix cache
    ///    - num: number of matrices from cache
    public static func setTransform(cache: UInt32, num: UInt16) {
        bgfx_set_transform_cached(cache, num)
    }

    // MARK: Conditional Rendering

    // MARK: Draw Buffers

    /// Sets the index buffer to use for drawing primitives
    ///
    /// - parameter buf: Index buffer
    public static func setIndexBuffer(buf: IndexBuffer) {
        bgfx_set_index_buffer(buf.handle, 0, UInt32.max)
    }

    /// Sets the index buffer to use for drawing primitives
    ///
    /// - parameters:
    ///
    ///    - buf: Index buffer
    ///    - firstIndex: First index to render
    ///    - count: Number of indices to render
    public static func setIndexBuffer(buf: IndexBuffer, firstIndex: UInt32, count: UInt32) {
        bgfx_set_index_buffer(buf.handle, firstIndex, count)
    }

    /// Sets the index buffer to use for drawing primitives
    ///
    /// - parameters:
    ///
    ///     - buf: Dynamic index buffer
    public static func setIndexBuffer(buf: DynamicIndexBuffer) {
        bgfx_set_dynamic_index_buffer(buf.handle, 0, UInt32.max)
    }

    /// Sets the index buffer to use for drawing primitives
    ///
    /// - parameters:
    ///
    ///     - buf: Dynamic index buffer
    ///     - firstIndex: First index to render
    ///     - count: Number of indices to render
    public static func setIndexBuffer(buf: DynamicIndexBuffer, firstIndex: UInt32, count: UInt32) {
        bgfx_set_dynamic_index_buffer(buf.handle, firstIndex, count)
    }

    /// Sets the index buffer to use for drawing primitives
    ///
    /// - parameters:
    ///
    ///     - buf: Transient index buffer
    public static func setIndexBuffer(buf: TransientIndexBuffer) {
        var d = unsafeBitCast(buf, bgfx_transient_index_buffer_t.self)
        bgfx_set_transient_index_buffer(&d, 0, UInt32.max)
    }

    /// Sets the index buffer to use for drawing primitives
    ///
    /// - parameters:
    ///
    ///     - buf: Transient index buffer
    ///     - firstIndex: First index to render
    ///     - count: Number of indices to render
    public static func setIndexBuffer(buf: TransientIndexBuffer, firstIndex: UInt32, count: UInt32) {
        var d = unsafeBitCast(buf, bgfx_transient_index_buffer_t.self)
        bgfx_set_transient_index_buffer(&d, firstIndex, count)
    }


    /// Sets the vertex buffer to use for drawing primitives
    ///
    /// - parameter buf: Vertex buffer
    public static func setVertexBuffer(buf: VertexBuffer) {
        bgfx_set_vertex_buffer(buf.handle, 0, UInt32.max)
    }

    /// Sets the vertex buffer to use for drawing primitives
    ///
    /// - parameters:
    ///
    ///    - buf: Vertex buffer
    ///     - firstVertex: First vertex to render
    ///    - count: Number of indices to render
    public static func setVertexBuffer(buf: VertexBuffer, firstVertex: UInt32, count: UInt32) {
        bgfx_set_vertex_buffer(buf.handle, firstVertex, count)
    }

    /// Sets the vertex buffer to use for drawing primitives
    ///
    /// - parameters:
    ///
    ///     - buf: Dynamic vertex buffer
    public static func setVertexBuffer(buf: DynamicVertexBuffer) {
        bgfx_set_dynamic_vertex_buffer(buf.handle, 0, UInt32.max)
    }

    /// Sets the vertex buffer to use for drawing primitives
    ///
    /// - parameters:
    ///
    ///     - buf: Dynamic vertex buffer
    ///     - firstVertex: First vertex to render
    ///     - count: Number of indices to render
    public static func setVertexBuffer(buf: DynamicVertexBuffer, firstVertex: UInt32, count: UInt32) {
        bgfx_set_dynamic_vertex_buffer(buf.handle, firstVertex, count)
    }

    /// Sets the vertex buffer to use for drawing primitives
    ///
    /// - parameters:
    ///
    ///     - buf: Transient vertex buffer
    public static func setVertexBuffer(buf: TransientVertexBuffer) {
        var d = unsafeBitCast(buf, bgfx_transient_vertex_buffer_t.self)
        bgfx_set_transient_vertex_buffer(&d, 0, UInt32.max)
    }

    /// Sets the vertex buffer to use for drawing primitives
    ///
    /// - parameters:
    ///
    ///     - buf: Transient vertex buffer
    ///     - firstVertex: First vertex to render
    ///     - count: Number of indices to render
    public static func setVertexBuffer(buf: TransientVertexBuffer, firstVertex: UInt32, count: UInt32) {
        var d = unsafeBitCast(buf, bgfx_transient_vertex_buffer_t.self)
        bgfx_set_transient_vertex_buffer(&d, firstVertex, count)
    }

    /// Sets instance data to use for drawing primitives
    ///
    /// - parameters:
    ///
    ///     - buf: The instance data
    ///     - count: The number of entries to pull from the buffer
    public static func setInstanceDataBuffer(buf: InstanceDataBuffer, count: UInt32 = UInt32.max) {
        bgfx_set_instance_data_buffer(buf.handle, count)
    }

    /// Sets instance data to use for drawing primitives
    ///
    /// - parameters:
    ///
    ///     - buf: The instance data
    ///     - firstVertex: First vertex to render
    ///     - count: The number of entries to pull from the buffer
    public static func setInstanceDataBuffer(buf: VertexBuffer, firstVertex: UInt32, count: UInt32) {
        bgfx_set_instance_data_from_vertex_buffer(buf.handle, firstVertex, count)
    }

    /// Sets instance data to use for drawing primitives
    ///
    /// - parameters:
    ///
    ///     - buf: The instance data
    ///     - firstVertex: First vertex to render
    ///     - count: The number of entries to pull from the buffer
    public static func setInstanceDataBuffer(buf: DynamicVertexBuffer, firstVertex: UInt32, count: UInt32) {
        bgfx_set_instance_data_from_dynamic_vertex_buffer(buf.handle, firstVertex, count)
    }

    /// Sets the value of a uniform parameter
    public static func setUniform(uniform: Uniform, value: float4) {
        var ptr = value
        bgfx_set_uniform(uniform.handle, &ptr, 1)
    }
    
    /// Sets the value of a uniform parameter
    public static func setUniform(uniform: Uniform, value: float4x4) {
        var ptr = value
        bgfx_set_uniform(uniform.handle, &ptr, 1)
    }
    
    /// Sets a texture to use for drawing primitives
    ///
    /// - parameters:
    ///
    ///    - unit: The texture unit to set
    ///    - sampler: The sampler uniform
    ///    - texture: The texture to set
    ///    - flags: Sampling flags that override the default flags in the texture itself
    public static func setTexture(unit: UInt8, sampler: Uniform, texture: Texture, flags: TextureFlags = [.Default]) {
        bgfx_set_texture(unit, sampler.handle, texture.handle, flags.rawValue)
    }

    /// Sets a texture to use for drawing primitives
    ///
    /// - parameters:
    ///
    ///    - unit: The texture unit to set
    ///    - sampler: The sampler uniform
    ///    - frameBuffer: The frame buffer
    ///    - attachment: The index of the attachment to set
    ///    - flags: Sampling flags that override the default flags in the texture itself
    public static func setTexture(unit: UInt8, sampler: Uniform, frameBuffer: FrameBuffer, attachment: UInt8 = 0, flags: TextureFlags = [.Default]) {
        bgfx_set_texture_from_frame_buffer(unit, sampler.handle, frameBuffer.handle, attachment, flags.rawValue)
    }

    /// Sets a texture mip as a compute image
    ///
    /// - parameters:
    ///
    ///    - stage: The buffer stage to set
    ///    - sampler: The sampler uniform
    ///    - texture: The texture to set
    ///    - mip: The index of the mip level within the texture to set
    ///    - access: Access control flags
    ///    - format: The format of the buffer data
    public static func setComputeImage(stage: UInt8, sampler: Uniform, texture: Texture, mip: UInt8, access: ComputeBufferAccess, format: TextureFormat = .Unknown) {
        bgfx_set_image(stage, sampler.handle, texture.handle, mip, bgfx_access_t(access.rawValue), bgfx_texture_format_t(format.rawValue))
    }

    /// Sets a frame buffer attachment as a compute image
    ///
    /// - parameters:
    ///
    ///    - stage: The buffer stage to set
    ///    - sampler: The sampler uniform
    ///    - frameBuffer: The frame buffer
    ///    - attachment: The attachment index
    ///    - access: Access control flags
    ///    - format: The format of the buffer data
    public static func setComputeImage(stage: UInt8, sampler: Uniform, frameBuffer: FrameBuffer, attachment: UInt8, access: ComputeBufferAccess, format: TextureFormat = .Unknown) {
        bgfx_set_image_from_frame_buffer(stage, sampler.handle, frameBuffer.handle, attachment, bgfx_access_t(access.rawValue), bgfx_texture_format_t(format.rawValue))
    }

    /// Sets an index buffer as a compute resource
    ///
    /// - parameters:
    ///
    ///    - stage: The buffer stage to set
    ///    - buffer: The buffer to set
    ///    - access: Access control flags
    public static func setComputeBuffer(stage: UInt8, buffer: IndexBuffer, access: ComputeBufferAccess) {
        bgfx_set_compute_index_buffer(stage, buffer.handle, bgfx_access_t(access.rawValue))
    }

    /// Sets a vertex buffer as a compute resource
    ///
    /// - parameters:
    ///
    ///    - stage: The buffer stage to set
    ///    - buffer: The buffer to set
    ///    - access: Access control flags
    public static func setComputeBuffer(stage: UInt8, buffer: VertexBuffer, access: ComputeBufferAccess) {
        bgfx_set_compute_vertex_buffer(stage, buffer.handle, bgfx_access_t(access.rawValue))
    }

    /// Sets a dynamic index buffer as a compute resource
    ///
    /// - parameters:
    ///
    ///    - stage: The buffer stage to set
    ///    - buffer: The buffer to set
    ///    - access: Access control flags
    public static func setComputeBuffer(stage: UInt8, buffer: DynamicIndexBuffer, access: ComputeBufferAccess) {
        bgfx_set_compute_dynamic_index_buffer(stage, buffer.handle, bgfx_access_t(access.rawValue))
    }

    /// Sets a dynamic vertex buffer as a compute resource
    ///
    /// - parameters:
    ///
    ///    - stage: The buffer stage to set
    ///    - buffer: The buffer to set
    ///    - access: Access control flags
    public static func setComputeBuffer(stage: UInt8, buffer: DynamicVertexBuffer, access: ComputeBufferAccess) {
        bgfx_set_compute_dynamic_vertex_buffer(stage, buffer.handle, bgfx_access_t(access.rawValue))
    }

    /// Sets an indirect buffer as a compute resource
    ///
    /// - parameters:
    ///
    ///    - stage: The buffer stage to set
    ///    - buffer: The buffer to set
    ///    - access: Access control flags
    public static func setComputeBuffer(stage: UInt8, buffer: IndirectBuffer, access: ComputeBufferAccess) {
        bgfx_set_compute_indirect_buffer(stage, buffer.handle, bgfx_access_t(access.rawValue))
    }

    /// Submit an empty primitive for rendering. Uniforms and draw state will be
    /// applied but no geometry will be submitted.
    ///
    /// These empty draw calls will sort before ordinary draw calls.
    ///
    /// - Parameters:
    ///     - viewId: the view ID
    ///
    /// - Returns: Number of draw calls
    public static func touch(viewId: UInt8) -> UInt32 {
        return bgfx_touch(viewId)
    }

    /// Resets all view settings to default
    public static func resetView(viewId: UInt8) {
        bgfx_reset_view(viewId)
    }

    /// Submits the current batch of primitives for rendering
    ///
    /// - parameters:
    ///
    ///    - viewId: The index of the view to submit
    ///    - program: The program with which to render
    ///    - depth: A depth value to use for sorting the batch
    ///    - preserveState: `true` to preserve internal draw state after the call
    ///
    /// - returns: Number of draw calls
    public static func submit(viewId: UInt8, program: Program, depth: Int32 = 0, preserveState: Bool = false) -> UInt32 {
        return bgfx_submit(viewId, program.handle, depth, preserveState)
    }

    /// Submits the current batch of primitives for rendering
    ///
    /// - parameters:
    ///
    ///    - viewId: The index of the view to submit
    ///    - program: The program with which to render
    ///    - query: An occlusion query to use as a predicate during rendering
    ///    - depth: A depth value to use for sorting the batch
    ///    - preserveState: `true` to preserve internal draw state after the call
    ///
    /// - returns: Number of draw calls
    public static func submit(viewId: UInt8, program: Program, query: OcclusionQuery, depth: Int32 = 0, preserveState: Bool = false) -> UInt32 {
        return bgfx_submit_occlusion_query(viewId, program.handle, query.handle, depth, preserveState)
    }

    /// Submits an indirect batch of drawing commands to be used for rendering
    ///
    /// - parameters:
    ///
    ///    - viewId: The index of the view to submit
    ///    - program: The program with which to render
    ///    - indirectBuffer: The buffer containing drawing commands
    ///    - startIndex: The index of the first command to process
    ///    - count: The number of commands to process from the buffer
    ///    - depth: A depth value to use for sorting the batch
    ///    - preserveState: `true` to preserve internal draw state after the call
    ///
    /// - returns: Number of draw calls
    public static func submit(viewId: UInt8, program: Program, indirectBuffer: IndirectBuffer, startIndex: UInt16 = 0, count: UInt16 = 1, depth: Int32 = 0, preserveState: Bool = false) -> UInt32 {
        return bgfx_submit_indirect(viewId, program.handle, indirectBuffer.handle, startIndex, count, depth, preserveState)
    }

    /// Discard all previously set state for draw or compute call
    public static func discard() {
        bgfx_discard()
    }

    /// Dispatches a compute job
    ///
    /// - parameters:
    ///
    ///    - viewId: The index of the view to dispatch
    ///    - program: The shader program to use
    ///    - xCount: The size of the job in the first dimension
    ///    - yCount: The size of the job in the second dimension
    ///    - zCount: The size of the job in the third dimension
    public static func dispatch(viewId: UInt8, program: Program, xCount: UInt16 = 1, yCount: UInt16 = 1, zCount: UInt16 = 1) {
        bgfx_dispatch(viewId, program.handle, xCount, yCount, zCount, 0)
    }

    /// Dispatches an indirect compute job
    ///
    /// - parameters:
    ///
    ///    - viewId: The index of the view to dispatch
    ///    - program: The shader program to use
    ///    - buffer: The buffer containing drawing commands
    ///    - xCount: The size of the job in the first dimension
    ///    - yCount: The size of the job in the second dimension
    ///    - zCount: The size of the job in the third dimension
    public static func dispatch(viewId: UInt8, program: Program, buffer: IndirectBuffer, startIndex: UInt16 = 1, count: UInt16 = 1, zCount: UInt16 = 1) {
        bgfx_dispatch_indirect(viewId, program.handle, buffer.handle, startIndex, count, 0)
    }
    
    /// Requests that a screenshot be saved. The ScreenshotTaken event will be fired to save the result
    ///
    /// - parameter filePath: The file path that will be passed to the callback event
    public static func saveScreenShot(filePath: String) {
        bgfx_save_screen_shot(filePath)
    }

    /// Set rendering states used to draw primitives
    ///
    /// - parameters:
    ///
    ///    - state: The set of states to set
    ///    - colorRgba: The color used for "factor" blending modes
    public static func setRenderState(state: RenderState, colorRgba: UInt32) {
        bgfx_set_state(state.rawValue, colorRgba)
    }

    /// Sets stencil test state
    ///
    /// - parameter frontFace: The stencil state to use for front faces
    public static func setStencil(frontFace frontFace: StencilFlags) {
        bgfx_set_stencil(frontFace.rawValue, StencilFlags.None.rawValue)
    }

    /// Sets stencil test state
    ///
    /// - parameters:
    ///
    ///    - frontFace: The stencil state to use for front faces
    ///    - backFace: The stencil state to use for back faces
    public static func setStencil(frontFace frontFace: StencilFlags, backFace: StencilFlags) {
        bgfx_set_stencil(frontFace.rawValue, backFace.rawValue)
    }
}
