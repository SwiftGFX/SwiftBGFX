//
//  main.swift
//  bgfx Test
//
//  Created by Stuart Carnie on 4/19/16.
//  Copyright © 2016 SGC. All rights reserved.
//

import simd
import SGLMath

struct PosColorVertex {
    let x, y, z: Float
    let col: UInt32
    
    init(_ x: Float, _ y: Float, _ z: Float, _ col: UInt32) {
        self.x = x
        self.y = y
        self.z = z
        self.col = col
    }
    
    static var layout: VertexLayout {
        let l = VertexLayout()
        l
            .begin()
            .add(.Position, num: 3, type: .Float)
            .add(.Color0, num: 4, type: .UInt8, normalized: true)
            .end()
        
        return l
    }
}

let cubeVertices: [PosColorVertex] = [
    PosColorVertex(-1.0,  1.0,  1.0, 0xff000000),
    PosColorVertex( 1.0,  1.0,  1.0, 0xff0000ff),
    PosColorVertex(-1.0, -1.0,  1.0, 0xff00ff00 ),
    PosColorVertex( 1.0, -1.0,  1.0, 0xff00ffff ),
    PosColorVertex(-1.0,  1.0, -1.0, 0xffff0000 ),
    PosColorVertex( 1.0,  1.0, -1.0, 0xffff00ff ),
    PosColorVertex(-1.0, -1.0, -1.0, 0xffffff00 ),
    PosColorVertex( 1.0, -1.0, -1.0, 0xffffffff ),
]

let cubeIndices: [UInt16] = [
    0, 1, 2, // 0
    1, 3, 2,
    4, 6, 5, // 2
    5, 6, 7,
    0, 2, 4, // 4
    4, 2, 6,
    1, 5, 3, // 6
    5, 7, 3,
    0, 4, 1, // 8
    4, 5, 1,
    2, 3, 6, // 10
    6, 3, 7,
]

class ExampleInstancing: AppI {
    var width: UInt16 = 1280
    var height: UInt16 = 720
    var debug: DebugOptions = [.Text]
    var reset: ResetOptions = .VSync
    
    var vbh: VertexBuffer?
    var ibh: IndexBuffer?
    var prog: Program?
    var timeOffset: UInt64 = 0
    
    
    func startup(argc: Int, argv: [String]) {
        bgfx.initialize()
        
        bgfx.reset(width: width, height: height, options: reset)
        bgfx.debug = debug
        bgfx.setViewClear(0, options: [.Color, .Depth], rgba: 0x30_30_30_ff, depth: 1.0, stencil: 0)
        
        vbh = VertexBuffer(memory: try! MemoryBlock.makeRef(cubeVertices), layout: PosColorVertex.layout)
        ibh = IndexBuffer(memory: try! MemoryBlock.makeRef(cubeIndices))
        
        do {
            prog = try loadProgram("vs_instancing", fsPath: "fs_instancing")
        } catch (FileError.PathError(let op, _, _)) {
            print("error: \(op)")
        } catch {
            print("unknown error")
        }
        
        last = Timing.counter
        offset = Timing.counter
        glmLeftHanded = true
        glmDepthZeroToOne = false
    }
    
    func shutdown() -> Int {
        bgfx.shutdown()
        
        return 0
    }
    
    var last: UInt64 = 0
    var offset: UInt64 = 0
    
    struct InstanceData {
        var mtx: mat4
        var col: vec4
    }
    
    func update() -> Bool {
        if !processEvents(&width, height: &height, debug: &debug, reset: &reset) {
            
            let now = Timing.counter
            let frameTime = now - last
            last = now
            let time = Float(now - offset) / 1000000000.0
            
            bgfx.debugTextClear()
            bgfx.debugTextPrint(x: 0, y: 1, foreColor: .White, backColor: .Blue, string: "bgfx/examples/05-instancing")
            bgfx.debugTextPrint(x: 0, y: 2, foreColor: .White, backColor: .Cyan, string: "Description: Geometry instancing")
            let frameTimeStr = String(format: "% 7.3f[ms]", (Double(frameTime) / 1000000000.0 * 1000.0))
            bgfx.debugTextPrint(x: 0, y: 3, foreColor: .White, backColor: .Transparent, string: "Frame: \(frameTimeStr)")
            
            if !bgfx.capabilities.supported.contains(.Instancing) {
                let blink = UInt32(time*3.0)&1 == 0x1
                let fore = blink ? DebugColor.White : DebugColor.Red
                let back = blink ? DebugColor.Red   : DebugColor.Transparent
                bgfx.debugTextPrint(x: 0, y: 5, foreColor: fore, backColor: back, string: " Instancing is not supported by GPU ")
            }
            
            let view = SGLMath.lookAt(
                vec3(x: 0.0, y: 0.0, z: -35.0),
                vec3(0),
                vec3(x: 0.0, y: 1.0, z: 0.0)
            )
            
            let proj = SGLMath.perspective(60.0/180.0*Float(M_PI), Float(width) / Float(height), 0.1, 100.0)
            let mtx = mat4(
                1.0, 0.0, 0.0, 0.0,
                0.0, 1.0, 0.0, 0.0,
                0.0, 0.0, 1.0, 0.0,
                0.0, 0.0, 0.0, 1.0
            )
            
            bgfx.setViewTransform(0, view: unsafeBitCast(view, float4x4.self), proj: unsafeBitCast(proj, float4x4.self))
            bgfx.setViewRect(0, x: 0, y: 0, width: width, height: height)
            bgfx.touch(0)
            
            let instanceStride = 80
            let idb = InstanceDataBuffer(count: 121, stride: instanceStride)
            var data = unsafeBitCast(idb.data, UnsafeMutablePointer<InstanceData>.self)
            
            for yy in 0...10 {
                for xx in 0...10 {
                    var m1 = SGLMath.rotate(mtx, time + Float(xx)*0.21, vec3(1.0, 0.0, 0.0))
                    m1 = SGLMath.rotate(m1, time + Float(yy)*0.37, vec3(0.0, 1.0, 0.0))
                    m1[3].x = -15.0 + Float(xx)*3.0
                    m1[3].y = -15.0 + Float(yy)*3.0
                    m1[3].z = 0.0
                    
                    data.memory.mtx = m1
                    data.memory.col = vec4(
                        x: sinf(time+Float(xx)/11.0)*0.5+0.5,
                        y: cosf(time+Float(yy)/11.0)*0.5+0.5,
                        z: sinf(time*3.0)*0.5+0.5,
                        w: 1.0)
                    
                    data = data.advancedBy(1)
                }
            }
            
            bgfx.setVertexBuffer(vbh!)
            bgfx.setIndexBuffer(ibh!)
            bgfx.setInstanceDataBuffer(idb)
            
            bgfx.setRenderState(.Default, colorRgba: 0x00)
            bgfx.submit(0, program: prog!)
            bgfx.frame()
            
            return true
        }
        
        return false
    }
}

public var sharedApp: AppI {
    return ExampleInstancing()
}

main()