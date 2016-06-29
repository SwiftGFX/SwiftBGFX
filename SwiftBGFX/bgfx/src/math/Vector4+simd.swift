//
//  Vector2.swift
//  SwiftBGFX
//
//  Created by Stuart Carnie on 6/25/16.
//  Copyright © 2016 SGC. All rights reserved.
//

#if !NOSIMD
    
import simd

extension Vector4f {
    public init() {
        self.d = float4()
    }
    
    public init(_ scalar: Float) {
        self.d = float4(scalar)
    }
    
    public init(_ x: Float, _ y: Float, _ z: Float, _ w: Float) {
        self.d = float4(x, y, z, w)
    }
    
    public init(x: Float, y: Float, z: Float, w: Float) {
        self.d = float4(x, y, z, w)
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

//MARK: functions

public func normalize(x: Vector4f) -> Vector4f {
    return unsafeBitCast(simd.normalize(x.d), to: Vector4f.self)
}

public func dot(x: Vector4f, y: Vector4f) -> Float {
    return simd.dot(x.d, y.d)
}

//MARK: operators

/// Negation of `rhs`.
public prefix func -(rhs: Vector4f) -> Vector4f {
    return unsafeBitCast(-rhs.d, to: Vector4f.self)
}

#endif
