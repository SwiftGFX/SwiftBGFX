// Copyright 2016 Stuart Carnie.
// License: https://github.com/stuartcarnie/SwiftBGFX#license-bsd-2-clause
//

import Cbgfx

///  Represents a compiled and linked shader program
public class Program {
    let handle: bgfx_program_handle_t
    
    /// Creates a new program with the specified shaders
    ///
    /// - parameter vertex: The vertex shader
    /// - parameter fragment: The fragment shader
    /// - parameter destroyShaders: specify `true` to release the shaders after creating the program
    public init(vertex: Shader, fragment: Shader, destroyShaders: Bool = false) {
        handle = bgfx_create_program(vertex.handle, fragment.handle, destroyShaders)
    }

    /// Creates a new compute program
    ///
    /// - parameter compute: The compute shader
    /// - parameter destroyShaders: specify `true` to release the shaders after creating the program
    public init(compute: Shader, destroyShaders: Bool = false) {
        handle = bgfx_create_compute_program(compute.handle, destroyShaders)
    }
    
    deinit {
        bgfx_destroy_program(handle)
    }
}
