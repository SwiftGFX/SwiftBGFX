//
//  main.swift
//  bgfx Test
//
//  Created by Stuart Carnie on 4/19/16.
//  Copyright © 2016 SGC. All rights reserved.
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

class ExampleCubes: AppI {
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
            prog = try loadProgram("vs_cubes", fsPath: "fs_cubes")
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

    func update() -> Bool {
        if !processEvents(&width, height: &height, debug: &debug, reset: &reset) {
            
            let now = Timing.counter
            let frameTime = now - last
            last = now
            let time = Float(now - offset) / 1000000000.0

            bgfx.debugTextClear()
            bgfx.debugTextPrint(x: 0, y: 1, foreColor: .white, backColor: .blue, string: "bgfx/examples/01-cubes")
            bgfx.debugTextPrint(x: 0, y: 2, foreColor: .white, backColor: .cyan, string: "Description: Rendering simple static mesh.")
            let frameTimeStr = String(format: "% 7.3f[ms]", (Double(frameTime) / 1000000000.0 * 1000.0))
            bgfx.debugTextPrint(x: 0, y: 3, foreColor: .white, backColor: .transparent, string: "Frame: \(frameTimeStr)")

            let view = Matrix4x4f.lookAt(eye: vec3(0.0, 0.0, -35.0), at: vec3(0))
            let proj = Matrix4x4f.proj(fovy: 60.0, aspect: Float(width)/Float(height), near: 0.1, far: 100.0)
            
            bgfx.setViewTransform(0, view: view, proj: proj)
            bgfx.setViewRect(0, x: 0, y: 0, width: width, height: height)
            bgfx.touch(0)
            
            for yy in 0...10 {
                for xx in 0...10 {
                    var mtx = Matrix4x4f.rotate(x: time + Float(xx)*0.21, y: time + Float(yy)*0.37)
                    mtx[3].x = -15.0 + Float(xx)*3.0
                    mtx[3].y = -15.0 + Float(yy)*3.0
                    mtx[3].z = 0.0
                    bgfx.setTransform(mtx)
                    
                    bgfx.setVertexBuffer(vbh!)
                    bgfx.setIndexBuffer(ibh!)
                    
                    bgfx.setRenderState(.Default, colorRgba: 0x00)
                    bgfx.submit(0, program: prog!)
                }
            }

            bgfx.frame()

            return true
        }

        return false
    }
}

public var sharedApp: AppI {
    return ExampleCubes()
}

main()
