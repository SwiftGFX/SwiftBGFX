// Copyright 2016 Stuart Carnie.
// License: https://github.com/stuartcarnie/SwiftBGFX#license-bsd-2-clause
//

import SwiftMath

struct PosColorTexCoord0Vertex {
    var x, y, z: Float
    var col: UInt32
    var u, v: Float
    
    init(_ x: Float, _ y: Float, _ z: Float, _ col: UInt32, _ u: Float, _ v: Float) {
        self.x = x
        self.y = y
        self.z = z
        self.col = col
        self.u = u
        self.v = v
    }
    
    static var layout: VertexLayout {
        let l = VertexLayout()
        l
            .begin()
            .add(attrib: .position, num: 3, type: .float)
            .add(attrib: .color0, num: 4, type: .uint8, normalized: true)
            .add(attrib: .texCoord0, num: 2, type: .float)
            .end()
        
        return l
    }
}

func renderScreenSpaceQuad(_ viewId: UInt8, program: Program, x: Float, y: Float, width: Float, height: Float) {
    var tvb = TransientVertexBuffer()
    var tib = TransientIndexBuffer()
    bgfx.allocateTransientBuffers(vertexCount: 4, layout: PosColorTexCoord0Vertex.layout, indexCount: 6, vertexBuffer: &tvb, indexBuffer: &tib)
    let vertex = UnsafeMutableBufferPointer(start: unsafeBitCast(tvb.data, to: UnsafeMutablePointer<PosColorTexCoord0Vertex>.self), count: 4)
    
    let zz = Float(0.0);
    
    let minx = x
    let maxx = x + width
    let miny = y
    let maxy = y + height
    
    let minu:Float = -1.0;
    let minv:Float = -1.0;
    let maxu:Float =  1.0;
    let maxv:Float =  1.0;
    
    vertex[0].x = minx;
    vertex[0].y = miny;
    vertex[0].z = zz;
    vertex[0].col = 0xff0000ff;
    vertex[0].u = minu;
    vertex[0].v = minv;
    
    vertex[1].x = maxx;
    vertex[1].y = miny;
    vertex[1].z = zz;
    vertex[1].col = 0xff00ff00;
    vertex[1].u = maxu;
    vertex[1].v = minv;
    
    vertex[2].x = maxx;
    vertex[2].y = maxy;
    vertex[2].z = zz;
    vertex[2].col = 0xffff0000;
    vertex[2].u = maxu;
    vertex[2].v = maxv;
    
    vertex[3].x = minx;
    vertex[3].y = maxy;
    vertex[3].z = zz;
    vertex[3].col = 0xffffffff;
    vertex[3].u = minu;
    vertex[3].v = maxv;
    
    let indices = UnsafeMutableBufferPointer(start: unsafeBitCast(tib.data, to: UnsafeMutablePointer<UInt16>.self), count: 6)
    indices[0] = 0
    indices[1] = 2
    indices[2] = 1
    indices[3] = 0
    indices[4] = 3
    indices[5] = 2
    
    bgfx.setRenderState(RenderState.default, colorRgba: 0x000)
    bgfx.setIndexBuffer(tib)
    bgfx.setVertexBuffer(tvb)
    bgfx.submit(viewId, program: program)
}

class ExampleRaymarch: AppI {
    var width: UInt16 = 1280
    var height: UInt16 = 720
    var debug: DebugOptions = [.text]
    var reset: ResetOptions = .vsync

    var u_mtx: Uniform?
    var u_lightDirTime: Uniform?
    var prog: Program?
    var timeOffset: UInt64 = 0
    
    
    func startup(_ argc: Int, argv: [String]) {
        bgfx.initialize()
        
        bgfx.reset(width: width, height: height, options: reset)
        bgfx.debug = debug
        bgfx.setViewClear(viewId: 0, options: [.color, .depth], rgba: 0x30_30_30_ff, depth: 1.0, stencil: 0)
        
        do {
            prog = try loadProgram("vs_raymarching", fsPath: "fs_raymarching")
        } catch (FileError.pathError(let op, _, _)) {
            print("error: \(op)")
        } catch {
            print("unknown error")
        }
        
        u_mtx = Uniform(name: "u_mtx", type: .matrix4x4)
        u_lightDirTime = Uniform(name: "u_lightDirTime", type: .vector4)
        
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
            bgfx.setViewRect(viewId: 0, x: 0, y: 0, width: width, height: height)
            bgfx.setViewRect(viewId: 1, x: 0, y: 0, width: width, height: height)
            
            bgfx.touch(0)
            
            let now = Timing.counter
            let frameTime = now - last
            last = now
            let time = Float(now - offset) / 1000000000.0
            
            bgfx.debugTextClear()
            bgfx.debugTextPrint(x: 0, y: 1, foreColor: .white, backColor: .blue, string: "bgfx/examples/03-raymarch")
            bgfx.debugTextPrint(x: 0, y: 2, foreColor: .white, backColor: .cyan, string: "Description: Updating shader uniforms")
            let frameTimeStr = String(format: "% 7.3f[ms]", (Double(frameTime) / 1000000000.0 * 1000.0))
            bgfx.debugTextPrint(x: 0, y: 3, foreColor: .white, backColor: .transparent, string: "Frame: \(frameTimeStr)")
            
            if !bgfx.capabilities.supported.contains(.instancing) {
                let blink = UInt32(time*3.0)&1 == 0x1
                let fore = blink ? DebugColor.white : DebugColor.red
                let back = blink ? DebugColor.red   : DebugColor.transparent
                bgfx.debugTextPrint(x: 0, y: 5, foreColor: fore, backColor: back, string: " Instancing is not supported by GPU ")
            }
            
            let view = Matrix4x4f.lookAt(eye: vec3(0.0, 0.0, -15.0), at: vec3(0))
            let proj = Matrix4x4f.proj(fovy: 60.degrees, aspect: Float(width)/Float(height), near: 0.1, far: 100.0)
            let mtx = Matrix4x4f(
                1.0, 0.0, 0.0, 0.0,
                0.0, 1.0, 0.0, 0.0,
                0.0, 0.0, 1.0, 0.0,
                0.0, 0.0, 0.0, 1.0
            )
            
            bgfx.setViewTransform(viewId: 0, view: view, proj: proj)
            
            let ortho = Matrix4x4f.ortho(left: 0, right: 1280, bottom: 720, top: 0, near: 0, far: 100)
            bgfx.setViewTransform(viewId: 1, proj: ortho)
            
            let vec = vec4(-0.5, -0.3, 0.2, time)
            bgfx.setUniform(u_lightDirTime!, value: vec)
            bgfx.setUniform(u_mtx!, value: mtx)
            
            bgfx.setViewTransform(viewId: 0, view: view, proj: proj)
            
            renderScreenSpaceQuad(1, program: prog!, x: 0, y: 0, width: 1280, height: 720);
            
            bgfx.frame()
            
            return true
        }
        
        return false
    }
}

var sharedApp: AppI {
    return ExampleRaymarch()
}

main()
