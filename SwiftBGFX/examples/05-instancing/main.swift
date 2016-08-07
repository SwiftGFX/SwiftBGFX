// Copyright 2016 Stuart Carnie.
// License: https://github.com/stuartcarnie/SwiftBGFX#license-bsd-2-clause
//

import SwiftMath

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
            .add(.position, num: 3, type: .float)
            .add(.color0, num: 4, type: .uint8, normalized: true)
            .end()
        
        return l
    }
}

let cubeVertices: [PosColorVertex] = [
    PosColorVertex(-1.0,  1.0,  1.0, 0xff000000),
    PosColorVertex( 1.0,  1.0,  1.0, 0xff0000ff),
    PosColorVertex(-1.0, -1.0,  1.0, 0xff00ff00),
    PosColorVertex( 1.0, -1.0,  1.0, 0xff00ffff),
    PosColorVertex(-1.0,  1.0, -1.0, 0xffff0000),
    PosColorVertex( 1.0,  1.0, -1.0, 0xffff00ff),
    PosColorVertex(-1.0, -1.0, -1.0, 0xffffff00),
    PosColorVertex( 1.0, -1.0, -1.0, 0xffffffff),
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
    
    
    func startup(_ argc: Int, argv: [String]) {
        bgfx.initialize()
        
        bgfx.reset(width: width, height: height, options: reset)
        bgfx.debug = debug
        bgfx.setViewClear(0, options: [.Color, .Depth], rgba: 0x30_30_30_ff, depth: 1.0, stencil: 0)
        
        vbh = VertexBuffer(memory: try! MemoryBlock.makeRef(cubeVertices), layout: PosColorVertex.layout)
        ibh = IndexBuffer(memory: try! MemoryBlock.makeRef(cubeIndices))
        
        do {
            prog = try loadProgram("vs_instancing", fsPath: "fs_instancing")
        } catch (FileError.pathError(let op, _, _)) {
            print("error: \(op)")
        } catch {
            print("unknown error")
        }
        
        last = Timing.counter
        offset = Timing.counter
    }
    
    func shutdown() -> Int {
        bgfx.shutdown()
        
        return 0
    }
    
    var last: UInt64 = 0
    var offset: UInt64 = 0
    
    struct InstanceData {
        var mtx: Matrix4x4f
        var col: Vector4f
    }
    
    func update() -> Bool {
        if !processEvents(&width, height: &height, debug: &debug, reset: &reset) {
            
            let now = Timing.counter
            let frameTime = now - last
            last = now
            let time = Float(now - offset) / 1000000000.0
            
            bgfx.debugTextClear()
            bgfx.debugTextPrint(x: 0, y: 1, foreColor: .white, backColor: .blue, string: "bgfx/examples/05-instancing")
            bgfx.debugTextPrint(x: 0, y: 2, foreColor: .white, backColor: .cyan, string: "Description: Geometry instancing")
            let frameTimeStr = String(format: "% 7.3f[ms]", (Double(frameTime) / 1000000000.0 * 1000.0))
            bgfx.debugTextPrint(x: 0, y: 3, foreColor: .white, backColor: .transparent, string: "Frame: \(frameTimeStr)")
            
            if !bgfx.capabilities.supported.contains(.Instancing) {
                let blink = UInt32(time*3.0)&1 == 0x1
                let fore = blink ? DebugColor.white : DebugColor.red
                let back = blink ? DebugColor.red   : DebugColor.transparent
                bgfx.debugTextPrint(x: 0, y: 5, foreColor: fore, backColor: back, string: " Instancing is not supported by GPU ")
            }
            
            let view = Matrix4x4f.lookAt(eye: vec3(0.0, 0.0, -35.0), at: vec3(0))
            let proj = Matrix4x4f.proj(fovy: 60.0, aspect: Float(width)/Float(height), near: 0.1, far: 100.0)
            
            bgfx.setViewTransform(0, view: view, proj: proj)
            bgfx.setViewRect(0, x: 0, y: 0, width: width, height: height)
            bgfx.touch(0)
            
            let instanceStride = 80
            let idb = InstanceDataBuffer(count: 121, stride: instanceStride)
            var data = unsafeBitCast(idb.data, to: UnsafeMutablePointer<InstanceData>.self)
            
            for yy in 0...10 {
                for xx in 0...10 {
                    let sy = Float(yy)*0.1 + 1.0
                    let s = Matrix4x4f.scale(sx: sy, sy: sy, sz: sy)
                    var mtx: Matrix4x4f = Matrix4x4f.rotate(x: time + Float(xx)*0.21, y: time + Float(yy)*0.37) * s
                    mtx[3].x = -15.0 + Float(xx)*3.0
                    mtx[3].y = -15.0 + Float(yy)*3.0
                    mtx[3].z = 0.0
                    
                    data.pointee.mtx = mtx
                    data.pointee.col = vec4(
                        x: sinf(time+Float(xx)/11.0)*0.5+0.5,
                        y: cosf(time+Float(yy)/11.0)*0.5+0.5,
                        z: sinf(time*3.0)*0.5+0.5,
                        w: 1.0)
                    
                    data = data.advanced(by: 1)
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
