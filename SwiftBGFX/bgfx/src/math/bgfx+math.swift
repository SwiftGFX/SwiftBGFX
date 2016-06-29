//
//  bgfx+math.swift
//  SwiftBGFX
//
//  Created by Stuart Carnie on 6/25/16.
//  Copyright © 2016 SGC. All rights reserved.
//

import simd

let invPi  = 1.0/Float.pi
let piHalf = Float.pi/2.0
let sqrt2  = Float(1.41421356237309504880)

extension bgfx {

    public static func toRad<T:BinaryFloatingPoint>(_ deg: T) -> T {
        return deg * T.pi / 180.0
    }
    
    public static func toDeg<T:BinaryFloatingPoint>(_ rad: T) -> T {
        return rad * 180.0 / T.pi
    }
    
    public static func clamp<T:Comparable>(x: T, min _min: T, max _max: T) -> T {
        return min(max(x, _min), _max)
    }
    
    public static func saturate<T:BinaryFloatingPoint>(x: T) -> T {
        return clamp(x: x, min: 0.0, max: 1.0)
    }
    
    /// lerp performs a linear interpolation between a and b by the interpolant t
    public static func lerp<T:BinaryFloatingPoint>(a: T, b: T, t: T) -> T {
        return a + (b - a) * t
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
        
        var r = Matrix4x4f()
        r[0,0] = right[0]
        r[0,1] = u[0]
        r[0,2] = view[0]
        
        r[1,0] = right[1]
        r[1,1] = u[1]
        r[1,2] = view[1]

        r[2,0] = right[2]
        r[2,1] = u[2]
        r[2,2] = view[2]
        
        r[3,0] = -dot(right, eye)
        r[3,1] = -dot(u, eye)
        r[3,2] = -dot(view, eye)
        r[3,3] = 1.0
        
        return r
    }
    
    public static func proj(fovy: Float, aspect: Float, near: Float, far: Float) -> Matrix4x4f {
    #if os(OSX) || os(iOS) || os(tvOS) || os(watchOS)
        let height = 1.0/__tanpif(fovy / 180.0 * 0.5)
    #else
        let height = 1.0/tanf(toRad(fovy)*0.5);
    #endif
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
