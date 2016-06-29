//
//  Matrix4x4.swift
//  SwiftBGFX
//
//  Created by Stuart Carnie on 6/29/16.
//  Copyright © 2016 SGC. All rights reserved.
//

#if !NOSIMD
    import simd
#endif

public typealias mat4 = Matrix4x4f

public struct Matrix4x4f {
    #if NOSIMD
    var r0, r1, r2, r3: Vector4f
    #else
    var d: float4x4
    #endif
    
    public init(
        _ r00: Float, _ r01: Float, _ r02: Float, _ r03: Float,
        _ r10: Float, _ r11: Float, _ r12: Float, _ r13: Float,
        _ r20: Float, _ r21: Float, _ r22: Float, _ r23: Float,
        _ r30: Float, _ r31: Float, _ r32: Float, _ r33: Float) {
        self.init(
            vec4(r00, r01, r02, r03),
            vec4(r10, r11, r12, r13),
            vec4(r20, r21, r22, r23),
            vec4(r30, r31, r32, r33)
        )
    }
    
    //MARK: matrix operations
    
    public static func lookAt(eye:Vector3f, at:Vector3f, up:Vector3f = Vector3f(0.0, 1.0, 0.0)) -> Matrix4x4f {
        return lookAtLH(eye: eye, at: at, up: up)
    }
    
    public static func lookAtLH(eye:Vector3f, at:Vector3f, up:Vector3f) -> Matrix4x4f {
        let view = normalize(at - eye)
        return lookAt(eye: eye, view: view, up: up)
    }
    
    static func lookAt(eye:Vector3f, view:Vector3f, up:Vector3f) -> Matrix4x4f {
        let right = normalize(cross(up, view))
        let u     = cross(view, right)
        
        return Matrix4x4f(
            right[0],         u[0],         view[0],         0.0,
            right[1],         u[1],         view[1],         0.0,
            right[2],         u[2],         view[2],         0.0,
            -dot(right, eye), -dot(u, eye), -dot(view, eye), 1.0
        )
    }
    
    public static func proj(fovy: Float, aspect: Float, near: Float, far: Float) -> Matrix4x4f {
        let height = 1.0 / __tanpif(fovy / 180.0 * 0.5)
        let width  = height * 1.0/aspect;
        return projLH(x: 0, y: 0, w: width, h: height, near: near, far: far)
    }
    
    public static func projLH(x: Float, y: Float, w: Float, h: Float, near: Float, far: Float) -> Matrix4x4f {
        let diff = far - near
        let aa   = far / diff
        let bb   = near * aa
        
        var r = Matrix4x4f()
        r[0,0] = w
        r[1,1] = h
        r[2,0] = -x
        r[2,1] = -y
        r[2,2] = aa
        r[2,3] = 1.0
        r[3,2] = -bb
        
        return r
    }
    
    public static func projRH(x: Float, y: Float, w: Float, h: Float, near: Float, far: Float) -> Matrix4x4f {
        let diff = far - near
        let aa   = far / diff
        let bb   = near * aa
        
        var r = Matrix4x4f()
        r[0,0] = w
        r[1,1] = h
        r[2,0] = x
        r[2,1] = y
        r[2,2] = -aa
        r[2,3] = -1.0
        r[3,2] = -bb
        
        return r
    }
    
    public static func ortho(left: Float, right: Float, bottom: Float, top: Float, near: Float, far: Float) -> Matrix4x4f {
        return orthoLH(left: left, right: right, bottom: bottom, top: top, near: near, far: far)
    }
    
    public static func orthoLH(left: Float, right: Float, bottom: Float, top: Float, near: Float, far: Float, offset: Float = 0.0) -> Matrix4x4f {
        let aa = 2.0 / (right - left)
        let bb = 2.0 / (top - bottom)
        let cc = 1.0 / (far - near)
        let dd = (left + right) / (left - right)
        let ee = (top + bottom) / (bottom - top)
        let ff = near / (near - far)
        
        var r = Matrix4x4f()
        r[0,0] = aa
        r[1,1] = bb
        r[2,2] = cc
        r[3,0] = dd + offset
        r[3,1] = ee
        r[3,2] = ff
        r[3,3] = 1.0
        
        return r
    }
    
    
    public static func orthoRH(left: Float, right: Float, bottom: Float, top: Float, near: Float, far: Float, offset: Float = 0.0) -> Matrix4x4f {
        let aa = 2.0 / (right - left)
        let bb = 2.0 / (top - bottom)
        let cc = 1.0 / (far - near)
        let dd = (left + right) / (left - right)
        let ee = (top + bottom) / (bottom - top)
        let ff = near / (near - far)
        
        var r = Matrix4x4f()
        r[0,0] = aa
        r[1,1] = bb
        r[2,2] = -cc
        r[3,0] = dd + offset
        r[3,1] = ee
        r[3,2] = ff
        r[3,3] = 1.0
        
        return r
    }

}
