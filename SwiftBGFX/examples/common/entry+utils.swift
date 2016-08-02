//
//  entry+utils.swift
//  bgfx Test
//
//  Created by Stuart Carnie on 4/25/16.
//  Copyright © 2016 SGC. All rights reserved.
//

import Foundation

public enum ProgramLoadError: Error {
    case loadFailed
}

extension AppI {
    public var runtimePath: String {
        let env = getenv("BGFX_RUNTIME_PATH")
        return env != nil ? String(cString: env!) : ""
    }
    
    var sep: String {
        return "/"
    }
    
    func loadProgram(_ vsPath: String, fsPath: String) throws -> Program {
        let vs = try loadShader(vsPath)
        let fs = try loadShader(fsPath)
        
        return Program(vertex: vs, fragment: fs)
    }
    
    func loadShader(_ shader: String) throws -> Shader {
        var base = [runtimePath]
        var path = "shaders/dx9/"
        
        switch bgfx.rendererType {
        case .direct3D11, .direct3D12:
            path = "shaders/dx11/"
            
        case .openGL:
            path = "shaders/glsl/"
            
        case .metal:
            path = "shaders/metal/"
            
        case .openGLES:
            path = "shaders/gles/"
            
        default:
            throw ProgramLoadError.loadFailed
        }
        
        base.append(path)
        base.append("\(shader).bin")
        
        let name = base.joined(separator: sep)
        let f = try open(name)
        defer {
            let _ = try? f.close()
        }
        
        var mem: [UInt8] = []
        var buf = [UInt8](repeating: 0, count: 4096)
        while let c = try? f.read(&buf), c > 0 {
            mem.append(contentsOf: buf[0..<c])
        }
        
        return Shader(memory: MemoryBlock(data: mem))
    }
}
