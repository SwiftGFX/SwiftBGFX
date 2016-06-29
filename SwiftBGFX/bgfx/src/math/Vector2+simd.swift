//
//  Vector2+simd.swift
//  SwiftBGFX
//
//  Created by Stuart Carnie on 6/25/16.
//  Copyright © 2016 SGC. All rights reserved.
//
#if !NOSIMD
    
    import simd
    
    extension Vector2f {
        public init() {
            self.d = float2()
        }
        
        public init(_ scalar: Float) {
            self.d = float2(scalar)
        }
        
        public init(_ x: Float, _ y: Float) {
            self.d = float2(x, y)
        }
        
        public init(x: Float, y: Float) {
            self.d = float2(x, y)
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
    
    public func normalize(_ x: Vector2f) -> Vector2f {
        return unsafeBitCast(simd.normalize(x.d), to: Vector2f.self)
    }
    
    public func dot(_ x: Vector2f, _ y: Vector2f) -> Float {
        return simd.dot(x.d, y.d)
    }
    
    public func cross(_ x: Vector2f, _ y: Vector2f) -> Vector2f {
        return unsafeBitCast(simd.cross(x.d, y.d), to: Vector2f.self)
    }
    
    public func -(lhs: Vector2f, rhs: Vector2f) -> Vector2f {
        return unsafeBitCast(lhs.d - rhs.d, to: Vector2f.self)
    }
    
#endif
