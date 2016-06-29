//
//  Vector3+simd.swift
//  SwiftBGFX
//
//  Created by Stuart Carnie on 6/25/16.
//  Copyright © 2016 SGC. All rights reserved.
//

import simd

public typealias Vector3f = float3
public typealias vec3     = Vector3f

public extension Vector3f {
    public var r: Float { get { return self.x } set { self.x = newValue } }
    public var g: Float { get { return self.y } set { self.y = newValue } }
    public var b: Float { get { return self.z } set { self.z = newValue } }
    
    public var s: Float { get { return self.x } set { self.x = newValue } }
    public var t: Float { get { return self.y } set { self.y = newValue } }
    public var p: Float { get { return self.z } set { self.z = newValue } }
}

