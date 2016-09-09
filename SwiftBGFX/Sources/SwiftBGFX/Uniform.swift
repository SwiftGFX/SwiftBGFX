// Copyright 2016 Stuart Carnie.
// License: https://github.com/stuartcarnie/SwiftBGFX#license-bsd-2-clause
//

import Cbgfx

/// Represents a shader uniform
///
/// - remark:
/// Predefined uniform names:
///
/// - `u_viewRect vec4(x, y, width, height)` - view rectangle for current view.
/// - `u_viewTexel vec4 (1.0/width, 1.0/height, undef, undef)` - inverse width and height
/// - `u_view mat4` - view matrix
/// - `u_invView mat4` - inverted view matrix
/// - `u_proj mat4` - projection matrix
/// - `u_invProj mat4` - inverted projection matrix
/// - `u_viewProj mat4` - concatenated view projection matrix
/// - `u_invViewProj mat4` - concatenated inverted view projection matrix
/// - `u_model mat4[BGFX_CONFIG_MAX_BONES]` - array of model matrices.
/// - `u_modelView mat4` - concatenated model view matrix, only first model matrix from array is used.
/// - `u_modelViewProj mat4` - concatenated model view projection matrix.
/// - `u_alphaRef float` - alpha reference value for alpha test.
///
public class Uniform {
    let handle: bgfx_uniform_handle_t
    
    init(handle: bgfx_uniform_handle_t) {
        self.handle = handle
    }
    
    /// Initializes a new instance
    ///
    /// - parameter name: The name of the uniform
    /// - parameter type: The type of data represented by the unifor
    /// - parameter num: Size of the array, if the uniform is an array type
    ///
    public init(name: String, type: UniformType, num: UInt16 = 1) {
        handle = bgfx_create_uniform(name, bgfx_uniform_type_t(type.rawValue), num)
    }
    
    deinit {
        bgfx_destroy_uniform(handle)
    }
}
