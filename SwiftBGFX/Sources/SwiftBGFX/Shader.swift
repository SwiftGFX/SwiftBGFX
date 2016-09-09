// Copyright 2016 Stuart Carnie.
// License: https://github.com/stuartcarnie/SwiftBGFX#license-bsd-2-clause
//

import Cbgfx

/// Represents a single compiled shader component
public class Shader {
    let handle: bgfx_shader_handle_t
    
    /// The set of uniforms exposed by the shader
    public lazy var uniforms: [Uniform] = {
        [unowned self] in
        var uh = bgfx_uniform_handle_t()
        
        let count = bgfx_get_shader_uniforms(self.handle, nil, 0)
        var hh = [bgfx_uniform_handle_t](repeating: bgfx_uniform_handle_t(), count: Int(count))
        
        bgfx_get_shader_uniforms(self.handle, &hh, count)

        return hh.map { Uniform(handle: $0) }
    }()
    
    // MARK: - creating new shaders
    
    /// Creates a new shader from memory
    ///
    /// - parameter memory: The compiled shader
    public init(memory: MemoryBlock) {
        handle = bgfx_create_shader(memory.handle)
    }
    
    /// Creates a new shader from source code
    ///
    /// - parameter source:   shader source code
    /// - parameter language: language of shader source
    /// - parameter type:     type of shader
    public init(source: String, language: ShaderLanguage, type: ShaderType) {
        let ds = DynamicShader(source: source, language: language, type: type)
        handle = bgfx_create_shader(ds.memory.handle)
    }
}

public enum ShaderLanguage {
    case metal
    case opengl
    case opengles
    case directx
}

public enum ShaderType {
    case vertex
    case fragment
    case compute
}
