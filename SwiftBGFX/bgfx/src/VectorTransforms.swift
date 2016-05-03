//
//  VectorTransforms.swift
//  MetalByExample
//
//  Created by Stuart Carnie on 2/26/16.
//  Copyright © 2016 SGC. All rights reserved.
//

import simd

//MARK: constants

private let kPi_f = Float(M_PI)
private let k1Div180_f: Float = 1.0 / 180.0
private let kRadians_f = k1Div180_f * kPi_f

//MARK:- private utilities

private func radians(degrees: Float) -> Float {
    return kRadians_f * degrees
}

//MARK:- scale transformations

func scale(x: Float, _ y: Float, _ z: Float) -> float4x4 {
    return float4x4(diagonal: float4(x, y, z,1))
}

/**
 scale creates a matrix

 - parameter s: The value of the scale

 - returns: a matrix for scaling
 */
func scale(s: float3) -> float4x4 {
    return float4x4(diagonal: float4(s.x, s.y, s.z, 1))
}

//MARK:- translate transformations

/**

 */
func translate(x: Float, _ y: Float, _ z: Float) -> float4x4 {
    return translate(float3(x, y, z))
}

func translate(t: float3) -> float4x4 {
    var m = matrix_identity_float4x4

    m.columns.3 = float4(t.x, t.y, t.z,1)

    return float4x4(m)
}

//MARK:- rotate transformations

private func RadiansOverPi(degrees: Float) -> Float {
    return degrees * k1Div180_f
}

func rotateXY(ax: Float, ay: Float) -> float4x4 {
    var sx = Float(0.0)
    var cx = Float(0.0)
    __sincosf(ax, &sx, &cx)
    var sy = Float(0.0)
    var cy = Float(0.0)
    __sincosf(ay, &sy, &cy)
    
    var mtx = float4x4()
    mtx[0][0] = cy
    mtx[0][2] = sy
    mtx[1][0] = sx*sy
    mtx[1][1] = cx
    mtx[1][2] = -sx*cy
    mtx[2][0] = -cx*sy
    mtx[2][1] = sx
    mtx[2][2] = cx*cy
    mtx[3][3] = 1.0
    
    return mtx
}

func rotate(angle: Float, _ x: Float, _ y: Float, _ z: Float) -> float4x4 {
    return rotate(angle, float3(x, y, z))
}

func rotate(angle: Float, _ r: float3) -> float4x4 {
    let a = RadiansOverPi(angle)
    var c = Float(0)
    var s = Float(0)

    // Computes the sine and cosine of pi times angle (measured in radians)
    // faster and gives exact results for angle = 90, 180, 270, etc.
    __sincospif(a, &s, &c)

    let k = 1.0 - c
    let u = normalize(r)
    let v = s * u
    let w = k * u

    var P = float4()
    var Q = float4()
    var R = float4()
    var S = float4()

    P.x = w.x * u.x + c
    P.y = w.x * u.y + v.z
    P.z = w.x * u.z - v.y

    Q.x = w.x * u.y - v.z
    Q.y = w.y * u.y + c
    Q.z = w.y * u.z + v.x

    R.x = w.x * u.z + v.y
    R.y = w.y * u.z - v.x
    R.z = w.z * u.z + c

    S.w = 1

    return float4x4([P, Q, R, S])
}

//MARK:- perspective transformations

func perspective(width: Float, height: Float, near: Float, far: Float) -> float4x4 {
    let zNear = 2.0 * near
    let zFar  = far / (far - near)

    var P = float4()
    var Q = float4()
    var R = float4()
    var S = float4()

    P.x =  zNear / width
    Q.y =  zNear / height
    R.z =  zFar
    R.w =  1.0
    S.z = -near * zFar

    return float4x4([P, Q, R, S])
}

func perspective_fov(fovy: Float, aspect: Float, near: Float, far: Float) -> float4x4 {
    let angle  = radians(0.5 * fovy)
    let yScale = 1 / tan(angle)
    let xScale = yScale / aspect
    let zScale = far / (far - near)

    var P = float4()
    var Q = float4()
    var R = float4()
    var S = float4()

    P.x =  xScale
    Q.y =  yScale
    R.z =  zScale
    R.w =  1.0
    S.z = -near * zScale

    return float4x4([P, Q, R, S])
}

func perspective_fov(fovy: Float, width: Float, height: Float, near: Float, far: Float) -> float4x4 {
    let aspect = width / height

    return perspective_fov(fovy, aspect: aspect, near: near, far: far)
}

//MARK:- look at transformations

func lookAt(eye eye: float3, center: float3, up: float3) -> float4x4 {
    let E = -eye
    let N = normalize(center + E)
    let U = normalize(cross(up, N))
    let V = cross(N, U)

    var P = float4()
    var Q = float4()
    var R = float4()
    var S = float4()

    P.x = U.x
    P.y = V.x
    P.z = N.x

    Q.x = U.y
    Q.y = V.y
    Q.z = N.y

    R.x = U.z
    R.y = V.z
    R.z = N.z

    S.x = dot(U, E)
    S.y = dot(V, E)
    S.z = dot(N, E)
    S.w = 1.0

    return float4x4([P, Q, R, S])
}

func lookAt(eye eye: [Float], center: [Float], up: [Float]) -> float4x4 {
    return lookAt(eye: float3(eye), center: float3(center), up: float3(up))
}

//MARK:- ortho2d transformations

func ortho2d(left left: Float, right: Float, bottom: Float, top: Float, near: Float, far: Float) -> float4x4 {
    let sLength = 1.0 / (right - left)
    let sHeight = 1.0 / (top   - bottom)
    let sDepth  = 1.0 / (far   - near)

    var P = float4()
    var Q = float4()
    var R = float4()
    var S = float4()

    P.x =  2.0 * sLength
    Q.y =  2.0 * sHeight
    R.z =  sDepth
    S.z = -near  * sDepth
    S.w =  1.0

    return float4x4([P, Q, R, S])
}

func ortho2d(origin: float3, size: float3) -> float4x4 {
    return ortho2d(left:origin.x, right: origin.y, bottom: origin.z, top: size.x, near: size.y, far: size.z)
}
