// Copyright 2016 Stuart Carnie.
// License: https://github.com/stuartcarnie/SwiftBGFX#license-bsd-2-clause
//

typealias InputBindingFn = (_ ud: Any) -> Void

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
