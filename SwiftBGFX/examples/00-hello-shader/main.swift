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
            .add(attrib: .position, num: 3, type: .float)
            .add(attrib: .color0, num: 4, type: .uint8, normalized: true)
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

let vs_shader =
    "using namespace metal; \n" +
        "struct xlatMtlShaderInput { \n" +
        "  float4 a_color0 [[attribute(0)]]; \n" +
        "  float3 a_position [[attribute(1)]]; \n" +
        "}; \n" +
        "struct xlatMtlShaderOutput { \n" +
        "  float4 gl_Position [[position]]; \n" +
        "  float4 v_color0; \n" +
        "}; \n" +
        "struct xlatMtlShaderUniform { \n" +
        "  float4x4 u_modelViewProj; \n" +
        "}; \n" +
        "vertex xlatMtlShaderOutput xlatMtlMain (xlatMtlShaderInput _mtl_i [[stage_in]], constant xlatMtlShaderUniform& _mtl_u [[buffer(0)]]) \n" +
        "{ \n" +
        "  xlatMtlShaderOutput _mtl_o; \n" +
        "  float4 tmpvar_1; \n" +
        "  tmpvar_1.w = 1.0; \n" +
        "  tmpvar_1.xyz = _mtl_i.a_position; \n" +
        "  _mtl_o.gl_Position = (_mtl_u.u_modelViewProj * tmpvar_1); \n" +
        "  _mtl_o.v_color0 = _mtl_i.a_color0; \n" +
        "  return _mtl_o; \n" +
"} \n";

let fs_shader =
    "using namespace metal; \n" +
        "struct xlatMtlShaderInput { \n" +
        "  float4 v_color0; \n" +
        "}; \n" +
        "struct xlatMtlShaderOutput { \n" +
        "  float4 gl_FragColor; \n" +
        "}; \n" +
        "struct xlatMtlShaderUniform { \n" +
        "}; \n" +
        "fragment xlatMtlShaderOutput xlatMtlMain (xlatMtlShaderInput _mtl_i [[stage_in]], constant xlatMtlShaderUniform& _mtl_u [[buffer(0)]]) \n" +
        "{ \n" +
        "  xlatMtlShaderOutput _mtl_o; \n" +
        "  _mtl_o.gl_FragColor = _mtl_i.v_color0; \n" +
        "  return _mtl_o; \n" +
"} \n"


class HelloWorld: AppI {
    private var width: UInt16 = 1280
    private var height: UInt16 = 720
    private var debug: DebugOptions = [.text]
    private var reset: ResetOptions = [.vsync]
    private var timer = Counter()
    
    var vbh: VertexBuffer?
    var ibh: IndexBuffer?
    var prog: Program?
    
    func startup(_ argc: Int, argv: [String]) {
        bgfx.initialize(type: .metal)
        
        bgfx.reset(width: width, height: height, options: reset)
        bgfx.debug = debug
        bgfx.setViewClear(viewId: 0, options: [.color, .depth], rgba: 0x30_30_30_ff, depth: 1.0, stencil: 0)
        
        vbh = VertexBuffer(memory: try! MemoryBlock.makeRef(data: cubeVertices), layout: PosColorVertex.layout)
        ibh = IndexBuffer(memory: try! MemoryBlock.makeRef(data: cubeIndices))
        
        let vs = Shader(source: vs_shader, language: .metal, type: .vertex)
        let fs = Shader(source: fs_shader, language: .metal, type: .fragment)
        prog = Program(vertex: vs, fragment: fs)
    }
    
    func shutdown() -> Int {
        bgfx.shutdown()
        
        return 0
    }
    
    func update() -> Bool {
        if !processEvents(&width, height: &height, debug: &debug, reset: &reset) {
            // Set view 0 default viewport.
            bgfx.setViewRect(viewId: 0, x: 0, y: 0, width: width, height: height)
            bgfx.touch(0)
            
            bgfx.debugTextClear()
            bgfx.debugTextPrint(x: 0, y: 1, foreColor: .white, backColor: .blue, string: "bgfx/examples/00-hello-shader")
            bgfx.debugTextPrint(x: 0, y: 2, foreColor: .white, backColor: .blue, format: "%08.4lf %s", timer.counter, "secs")
            
            let view = Matrix4x4f.lookAt(eye: vec3(0.0, 0.0, -35.0), at: vec3(0))
            let proj = Matrix4x4f.proj(fovy: 60.0, aspect: Float(width)/Float(height), near: 0.1, far: 100.0)
            
            bgfx.setViewTransform(viewId: 0, view: view, proj: proj)
            bgfx.setViewRect(viewId: 0, x: 0, y: 0, width: width, height: height)
            bgfx.touch(0)
            
            let mtx = Matrix4x4f.scaleRotateTranslate(sx: 3.0, sy: 3.0, sz: 3.0, ax: Float(timer.counter) * 0.8, ay: Float(timer.counter), az: 0.0, tx: 0.0, ty: 0.0, tz: 0.0)
            
            bgfx.setTransform(mtx)
            bgfx.setVertexBuffer(vbh!)
            bgfx.setIndexBuffer(ibh!)
            
            bgfx.setRenderState(.default, colorRgba: 0x00)
            bgfx.submit(0, program: prog!)
            
            bgfx.frame()
            
            return true
        }
        
        return false
    }
}

var sharedApp: AppI {
    return HelloWorld()
}

main()
