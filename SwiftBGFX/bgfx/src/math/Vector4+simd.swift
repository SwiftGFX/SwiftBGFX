//
//  Vector2.swift
//  SwiftBGFX
//
//  Created by Stuart Carnie on 6/25/16.
//  Copyright © 2016 SGC. All rights reserved.
//

import simd

public typealias Vector4f = float4
public typealias vec4     = Vector4f

public extension Vector4f {
    public var r: Float { get { return self.x } set { self.x = newValue } }
    public var g: Float { get { return self.y } set { self.y = newValue } }
    public var b: Float { get { return self.z } set { self.z = newValue } }
    public var a: Float { get { return self.w } set { self.w = newValue } }
    
    public var s: Float { get { return self.x } set { self.x = newValue } }
    public var t: Float { get { return self.y } set { self.y = newValue } }
    public var p: Float { get { return self.z } set { self.z = newValue } }
    public var q: Float { get { return self.w } set { self.w = newValue } }
}

