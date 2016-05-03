//
//  program.swift
//  bgfx Test
//
//  Created by Stuart Carnie on 4/22/16.
//  Copyright © 2016 SGC. All rights reserved.
//

///  Represents a compiled and linked shader program
public class Program {
    let handle: bgfx_program_handle_t
    
    /// Initializes a new program with the specified shaders
    ///
    /// - parameters:
    ///
    ///    - vertex: The vertex shader
    ///    - fragment: The fragment shader
    ///    - destroyShaders: specify `true` to release the shaders after creating the program
    public init(vertex: Shader, fragment: Shader, destroyShaders: Bool = false) {
        handle = bgfx_create_program(vertex.handle, fragment.handle, destroyShaders)
    }
    
    /// Initializes a new compute program
    ///
    /// - parameters:
    ///
    ///    - compute: The compute shader
    ///    - destroyShaders: specify `true` to release the shaders after creating the program
    public init(compute: Shader, destroyShaders: Bool = false) {
        handle = bgfx_create_compute_program(compute.handle, destroyShaders)
    }
    
    deinit {
        bgfx_destroy_program(handle)
    }
}