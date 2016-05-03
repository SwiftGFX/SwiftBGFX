//
//  shader.swift
//  bgfx Test
//
//  Created by Stuart Carnie on 4/22/16.
//  Copyright © 2016 SGC. All rights reserved.
//

public class Shader {
    let handle: bgfx_shader_handle_t
    
    public lazy var uniforms: [Uniform] = {
        [unowned self] in
        var uh = bgfx_uniform_handle_t()
        
        let count = bgfx_get_shader_uniforms(self.handle, nil, 0)
        var hh = [bgfx_uniform_handle_t](count: Int(count), repeatedValue: bgfx_uniform_handle_t())
        
        bgfx_get_shader_uniforms(self.handle, &hh, count)

        return hh.map { Uniform(handle: $0) }
    }()
    
    public init(memory: MemoryBlock) {
        handle = bgfx_create_shader(memory.handle)
    }
}
