//
//  Matrix4x4+simd.swift
//  SwiftBGFX
//
//  Created by Stuart Carnie on 6/25/16.
//  Copyright © 2016 SGC. All rights reserved.
//

import simd

public typealias Matrix4x4f = float4x4
public typealias mat4       = Matrix4x4f

public extension Matrix4x4f {
    public init(
        _ r00: Float, _ r01: Float, _ r02: Float, _ r03: Float,
        _ r10: Float, _ r11: Float, _ r12: Float, _ r13: Float,
        _ r20: Float, _ r21: Float, _ r22: Float, _ r23: Float,
        _ r30: Float, _ r31: Float, _ r32: Float, _ r33: Float) {
        let c = matrix_float4x4(columns: (
            vec4(r00, r01, r02, r03),
            vec4(r10, r11, r12, r13),
            vec4(r20, r21, r22, r23),
            vec4(r30, r31, r32, r33)
            ))
        self.init(c)
    }
    
    public static func rotateXY(x: Float, y: Float) -> Matrix4x4f {
    #if os(OSX) || os(iOS) || os(tvOS) || os(watchOS)
        var sx: Float = 0.0, cx: Float = 0.0
        __sincosf(x, &sx, &cx)
        var sy: Float = 0.0, cy: Float = 0.0
        __sincosf(x, &sy, &cy)
    #else
        
    #endif
        var r = Matrix4x4f()
        r[0,0] = cy
        r[0,2] = sy
        r[1,0] = sx*sy
        r[1,1] = cx
        r[1,2] = -sx*cy
        r[2,0] = -cx*sy
        r[2,1] = sx
        r[2,2] = cx*cy
        r[3,3] = 1.0
        
        return r
    }
}
