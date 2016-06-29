//
//  Matrix4x4+nosimd.swift
//  SwiftBGFX
//
//  Created by Stuart Carnie on 6/29/16.
//  Copyright © 2016 SGC. All rights reserved.
//

#if NOSIMD

public extension Matrix4x4f {
    
    public init () {
        self.r0 = vec4()
        self.r1 = vec4()
        self.r2 = vec4()
        self.r3 = vec4()
    }
    
    
    public init(diagonal d: Vector4f) {
        self.r0 = vec4(d.x, 0.0, 0.0, 0.0)
        self.r1 = vec4(0.0, d.y, 0.0, 0.0)
        self.r2 = vec4(0.0, 0.0, d.z, 0.0)
        self.r3 = vec4(0.0, 0.0, 0.0, d.w)
    }
    
    public subscript(col: Int) -> Vector4f {
        get {
            switch col {
            case 0:
                return r0
            case 1:
                return r1
            case 2:
                return r2
            case 3:
                return r3
            default:
                fatalError("Row index out of range")
            }
        }
        
        set {
            switch col {
            case 0:
                return r0
            case 1:
                return r1
            case 2:
                return r2
            case 3:
                return r3
            default:
                fatalError("Row index out of range")
            }
        }
    }
}

#endif
