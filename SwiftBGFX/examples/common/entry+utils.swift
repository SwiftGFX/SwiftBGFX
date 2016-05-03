//
//  entry+utils.swift
//  bgfx Test
//
//  Created by Stuart Carnie on 4/25/16.
//  Copyright © 2016 SGC. All rights reserved.
//

import Foundation

public enum ProgramLoadError: ErrorType {
    case LoadFailed
}

extension AppI {
    public var runtimePath: String {
        let env = getenv("BGFX_RUNTIME_PATH")
        return env != nil ? String(CString: env, encoding: NSASCIIStringEncoding)! : ""
    }
    
    var sep: String {
        return "/"
    }
    
    func loadProgram(vsPath: String, fsPath: String) throws -> Program {
        let vs = try loadShader(vsPath)
        let fs = try loadShader(fsPath)
        
        return Program(vertex: vs, fragment: fs)
    }
    
    func loadShader(shader: String) throws -> Shader {
        var base = [runtimePath]
        var path = "shaders/dx9/"
        
        switch bgfx.rendererType {
        case .Direct3D11, .Direct3D12:
            path = "shaders/dx11/"
            
        case .OpenGL:
            path = "shaders/glsl/"
            
        case .Metal:
            path = "shaders/metal/"
            
        case .OpenGLES:
            path = "shaders/gles/"
            
        default:
            throw ProgramLoadError.LoadFailed
        }
        
        base.append(path)
        base.append("\(shader).bin")
        
        let name = base.joinWithSeparator(sep)
        let f = try open(name)
        defer {
            let _ = try? f.close()
        }
        
        var mem: [UInt8] = []
        var buf = [UInt8](count: 4096, repeatedValue: 0)
        while let c = try? f.read(&buf) where c > 0 {
            mem.appendContentsOf(buf[0..<c])
        }
        
        return Shader(memory: MemoryBlock(data: mem))
    }
}