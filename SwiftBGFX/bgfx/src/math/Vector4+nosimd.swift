//
//  Vector4+nosimd.swift
//  SwiftBGFX
//
//  Created by Stuart Carnie on 6/29/16.
//  Copyright © 2016 SGC. All rights reserved.
//
#if NOSIMD
    
    public extension Vector4f {
        public init() {
            self.x = 0
            self.y = 0
            self.z = 0
            self.w = 0
        }
        
        public init(_ x: Float, _ y: Float, _ z: Float, _ w: Float) {
            self.x = x
            self.y = y
            self.z = z
            self.w = w
        }
        
        public subscript(i: Int) -> Float {
            get {
                switch i {
                case 0:
                    return x
                case 1:
                    return y
                case 2:
                    return z
                case 3:
                    return w
                default:
                    fatalError("vector index out of range")
                }
            }
            
            set {
                switch i {
                case 0:
                    x = newValue
                case 1:
                    y = newValue
                case 2:
                    z = newValue
                case 3:
                    w = newValue
                default:
                    fatalError("vector index out of range")
                }
            }
        }
    }
    
#endif
