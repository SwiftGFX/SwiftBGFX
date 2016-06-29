//
//  Vector3.swift
//  SwiftBGFX
//
//  Created by Stuart Carnie on 6/29/16.
//  Copyright © 2016 SGC. All rights reserved.
//

#if !NOSIMD
    import simd
#endif

public typealias vec3 = Vector3f

public struct Vector3f {
    #if NOSIMD
    public var x, y, z: Float
    #else
    var d: float3
    
    public var x: Float { get { return d.x } set { d.x = newValue } }
    public var y: Float { get { return d.y } set { d.y = newValue } }
    public var z: Float { get { return d.z } set { d.z = newValue } }
    #endif
    
    public var r: Float { get { return self.x } set { self.x = newValue } }
    public var g: Float { get { return self.y } set { self.y = newValue } }
    public var b: Float { get { return self.z } set { self.z = newValue } }
    
    public var s: Float { get { return self.x } set { self.x = newValue } }
    public var t: Float { get { return self.y } set { self.y = newValue } }
    public var p: Float { get { return self.z } set { self.z = newValue } }
}
