//
//  input.swift
//  bgfx Test
//
//  Created by Stuart Carnie on 4/20/16.
//  Copyright © 2016 SGC. All rights reserved.
//

typealias InputBindingFn = (ud: Any) -> Void

struct InputBinding {
    let key: KeyCode
    let modifiers: KeyModifier
    let fn: InputBindingFn?
    let userData: Any?
}

class Input {
    typealias InputBindingMap = Dictionary<String, InputBinding>
    
    let bindings = InputBindingMap()
    
    
}