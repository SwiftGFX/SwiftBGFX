//
//  Vector2.swift
//  SwiftBGFX
//
//  Created by Stuart Carnie on 6/25/16.
//  Copyright © 2016 SGC. All rights reserved.
//

import simd

public typealias Vector2f = float2
public typealias vec2     = Vector2f

public extension Vector2f {
    public var r: Float { get { return self.x } set { self.x = newValue } }
    public var g: Float { get { return self.y } set { self.y = newValue } }

    public var s: Float { get { return self.x } set { self.x = newValue } }
    public var t: Float { get { return self.y } set { self.y = newValue } }
}

