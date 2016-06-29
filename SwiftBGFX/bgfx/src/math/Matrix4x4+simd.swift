//
//  Matrix4x4+simd.swift
//  SwiftBGFX
//
//  Created by Stuart Carnie on 6/25/16.
//  Copyright © 2016 SGC. All rights reserved.
//

#if !NOSIMD
    
import simd

public extension Matrix4x4f {
    /// returns the identity matrix
    public static let identity = Matrix4x4f(diagonal: vec4(1.0))
    
    public init() {
        self.d = float4x4()
    }
    
    public init(diagonal v: Vector4f) {
        self.d = float4x4(diagonal: v.d)
    }
    
    public init(_ r0: Vector4f, _ r1: Vector4f, _ r2: Vector4f, _ r3: Vector4f) {
        self.d = float4x4(matrix_float4x4(columns: (r0.d, r1.d, r2.d, r3.d)))
    }
    
    //MARK subscript operations
    
    public subscript(col: Int) -> Vector4f {
        get {
            return unsafeBitCast(d[col], to: Vector4f.self)
        }
        
        set {
            d[col] = newValue.d
        }
    }
    
    public subscript(col: Int, row: Int) -> Float {
        get {
            return d[col, row]
        }
        
        set {
            d[col, row] = newValue
        }
    }
    
    //MARK matrix operations
    
    public static func scale(sx: Float, sy: Float, sz: Float) -> Matrix4x4f {
        return Matrix4x4f(diagonal: vec4(sx, sy, sz, 1.0))
    }
    
    public static func rotate(x: Float) -> Matrix4x4f {
        var sx: Float = 0.0, cx: Float = 0.0
        __sincosf(x, &sx, &cx)

        var r = Matrix4x4f()
        r[0,0] = 1.0
        r[1,1] = cx
        r[1,2] = -sx
        r[2,1] = sx
        r[2,2] = cx
        r[3,3] = 1.0
        
        return r
    }
    
    public static func rotate(y: Float) -> Matrix4x4f {
        var sy: Float = 0.0, cy: Float = 0.0
        __sincosf(y, &sy, &cy)
        
        var r = Matrix4x4f()
        r[0,0] = cy
        r[0,2] = sy
        r[1,1] = 1.0
        r[2,0] = -sy
        r[2,2] = cy
        r[3,3] = 1.0
        
        return r
    }
    
    public static func rotate(z: Float) -> Matrix4x4f {
        var sz: Float = 0.0, cz: Float = 0.0
        __sincosf(z, &sz, &cz)
        
        var r = Matrix4x4f()
        r[0,0] = cz
        r[0,1] = -sz
        r[1,0] = sz
        r[1,1] = cz
        r[2,2] = 1.0
        r[3,3] = 1.0
        
        return r
    }
    
    public static func rotate(x: Float, y: Float) -> Matrix4x4f {
        var sx: Float = 0.0, cx: Float = 0.0
        __sincosf(x, &sx, &cx)
        var sy: Float = 0.0, cy: Float = 0.0
        __sincosf(y, &sy, &cy)

        return Matrix4x4f(
            vec4(cy,     0.0, sy,     0.0),
            vec4(sx*sy,  cx,  -sx*cy, 0.0),
            vec4(-cx*sy, sx,  cx*cy,  0.0),
            vec4(0.0,    0.0, 0.0,    1.0)
        )
    }
    
    public static func rotate(x: Float, y: Float, z: Float) -> Matrix4x4f {
        var sx: Float = 0.0, cx: Float = 0.0
        __sincosf(x, &sx, &cx)
        var sy: Float = 0.0, cy: Float = 0.0
        __sincosf(y, &sy, &cy)
        var sz: Float = 0.0, cz: Float = 0.0
        __sincosf(z, &sz, &cz)
        
        var r = Matrix4x4f()
        r[0,0] = cy*cz
        r[0,1] = -cy*sz
        r[0,2] = sy
        r[1,0] = cz*sx*sy + cx*sz
        r[1,1] = cx*cz - sx*sy*sz
        r[1,2] = -cy*sx
        r[2,0] = -cx*cz*sy + sx*sz
        r[2,1] = cz*sx + cx*sy*sz
        r[2,2] = cx*cy
        r[3,3] = 1.0
        
        return r
    }

    public static func rotate(z: Float, y: Float, x: Float) -> Matrix4x4f {
        var sx: Float = 0.0, cx: Float = 0.0
        __sincosf(x, &sx, &cx)
        var sy: Float = 0.0, cy: Float = 0.0
        __sincosf(y, &sy, &cy)
        var sz: Float = 0.0, cz: Float = 0.0
        __sincosf(z, &sz, &cz)
        
        var r = Matrix4x4f()
        r[0,0] = cy*cz
        r[0,1] = cz*sx*sy-cx*sz
        r[0,2] = cx*cz*sy+sx*sz
        r[1,0] = cy*sz
        r[1,1] = cx*cz + sx*sy*sz
        r[1,2] = -cz*sx + cx*sy*sz
        r[2,0] = -sy
        r[2,1] = cy*sx
        r[2,2] = cx*cy
        r[3,3] = 1.0
        
        return r
    }

    public static func scaleRotateTranslate(sx _sx: Float, sy _sy: Float, sz _sz: Float,
                                            ax: Float, ay: Float, az: Float,
                                            tx: Float, ty: Float, tz: Float) -> Matrix4x4f {
        var sx: Float = 0.0, cx: Float = 0.0
        __sincosf(ax, &sx, &cx)
        var sy: Float = 0.0, cy: Float = 0.0
        __sincosf(ay, &sy, &cy)
        var sz: Float = 0.0, cz: Float = 0.0        
        __sincosf(az, &sz, &cz)
        
        let sxsz = sx*sz
        let cycz = cy*cz
        
        return Matrix4x4f(
            _sx * (cycz - sxsz*sy),   _sx * -cx*sz, _sx * (cz*sy + cy*sxsz), 0.0,
            _sy * (cz*sx*sy + cy*sz), _sy * cx*cz,  _sy * (sy*sz - cycz*sx), 0.0,
            _sz * -cx*sy,             _sz * sx,     cx*cy,                   0.0,
            tx,                       ty,           tz,                      1.0
        )
    }
}

/// Matrix multiplication
public func *(lhs: Matrix4x4f, rhs: Matrix4x4f) -> Matrix4x4f {
    return unsafeBitCast(lhs.d * rhs.d, to: Matrix4x4f.self)
}

#endif
