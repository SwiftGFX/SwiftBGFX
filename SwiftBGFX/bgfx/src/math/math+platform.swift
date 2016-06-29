//
//  math+platform.swift
//  SwiftBGFX
//
//  Created by Stuart Carnie on 6/29/16.
//  Copyright © 2016 SGC. All rights reserved.
//

#if !(os(OSX) || os(iOS) || os(tvOS) || os(watchOS))

    func __sincosf(_ a: Float, _ sina: inout Float, cosa: inout Float) {
        sina = sin(a)
        cosa = cos(a)
    }

    func __tanpif(_ a: Float) -> Float {
        return tan(a * Float.pi)
    }
    
#endif
