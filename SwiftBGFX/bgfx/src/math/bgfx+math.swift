//
//  bgfx+math.swift
//  SwiftBGFX
//
//  Created by Stuart Carnie on 6/25/16.
//  Copyright © 2016 SGC. All rights reserved.
//

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
}
