//
//  Vector4.swift
//  SwiftBGFX
//
//  Created by Stuart Carnie on 6/29/16.
//  Copyright © 2016 SGC. All rights reserved.
//

#if !NOSIMD
import simd
#endif

public typealias vec4 = Vector4f

public struct Vector4f {
    #if NOSIMD
    public var x, y, z, w: Float
    #else
    var d: float4
    
    public var x: Float { get { return d.x } set { d.x = newValue } }
    public var y: Float { get { return d.y } set { d.y = newValue } }
    public var z: Float { get { return d.z } set { d.z = newValue } }
    public var w: Float { get { return d.w } set { d.w = newValue } }
    #endif
    
    public var r: Float { get { return self.x } set { self.x = newValue } }
    public var g: Float { get { return self.y } set { self.y = newValue } }
    public var b: Float { get { return self.z } set { self.z = newValue } }
    public var a: Float { get { return self.w } set { self.w = newValue } }
    
    public var s: Float { get { return self.x } set { self.x = newValue } }
    public var t: Float { get { return self.y } set { self.y = newValue } }
    public var p: Float { get { return self.z } set { self.z = newValue } }
    public var q: Float { get { return self.w } set { self.w = newValue } }

}
