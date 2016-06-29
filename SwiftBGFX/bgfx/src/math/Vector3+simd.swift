//
//  Vector3.swift
//  SwiftBGFX
//
//  Created by Stuart Carnie on 6/25/16.
//  Copyright © 2016 SGC. All rights reserved.
//
#if !NOSIMD

import simd

extension Vector3f {
    public init() {
        self.d = float3()
    }
    
    public init(_ scalar: Float) {
        self.d = float3(scalar)
    }
    
    public init(_ x: Float, _ y: Float, _ z: Float) {
        self.d = float3(x, y, z)
    }
    
    public init(x: Float, y: Float, z: Float) {
        self.d = float3(x, y, z)
    }
    
    public subscript(x: Int) -> Float {
        get {
            return d[x]
        }
        
        set {
            d[x] = newValue
        }
    }
}

public func normalize(_ x: Vector3f) -> Vector3f {
    return unsafeBitCast(simd.normalize(x.d), to: Vector3f.self)
}

public func dot(_ x: Vector3f, _ y: Vector3f) -> Float {
    return simd.dot(x.d, y.d)
}

public func cross(_ x: Vector3f, _ y: Vector3f) -> Vector3f {
    return unsafeBitCast(simd.cross(x.d, y.d), to: Vector3f.self)
}

public func -(lhs: Vector3f, rhs: Vector3f) -> Vector3f {
    return unsafeBitCast(lhs.d - rhs.d, to: Vector3f.self)
}

#endif
