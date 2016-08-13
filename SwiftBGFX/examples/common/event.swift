// Copyright 2016 Stuart Carnie.
// License: https://github.com/stuartcarnie/SwiftBGFX#license-bsd-2-clause
//

enum GamepadAxis {
    case leftX, leftY, leftZ, rightX, rightY, rightZ
}

enum KeyCode: Int32 {
    case none

    case esc, `return`, tab, space, backspace
    case up, down, left, right
    case insert, delete, home, end, pageUp, pageDown
    case print

    case plus, minus, leftBracket, rightBracket, semicolon
    case quote, comma, period, slash, backslash, tilde

    case f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11, f12

    case numPad0, numPad1, numPad2, numPad3, numPad4
    case numPad5, numPad6, numPad7, numPad8, numPad9

    case key0, key1, key2, key3, key4, key5, key6, key7, key8, key9

    case keyA, keyB, keyC, keyD, keyE, keyF, keyG, keyH
    case keyI, keyJ, keyK, keyL, keyM, keyN, keyO, keyP
    case keyQ, keyR, keyS, keyT, keyU, keyV, keyW, keyX
    case keyY, keyZ

    case gamepadA, gamepadB, gamepadX, gamepadY, gamepadThumbL, gamepadThumbR
    case gamepadShoulderL, gamepadShoulderR, gamepadUp, gamepadDown, gamepadLeft
    case gamepadRight, gamepadBack, gamepadStart, gamepadGuide
}

struct KeyModifier : OptionSet {
    let rawValue: UInt8
    init(rawValue: UInt8) { self.rawValue = rawValue }

    static let None = KeyModifier(rawValue: 0x00)
    static let LeftAlt = KeyModifier(rawValue: 0x01)
    static let RightAlt = KeyModifier(rawValue: 0x02)
    static let LeftCtrl = KeyModifier(rawValue: 0x04)
    static let RightCtrl = KeyModifier(rawValue: 0x08)
    static let LeftShift = KeyModifier(rawValue: 0x10)
    static let RightShift = KeyModifier(rawValue: 0x20)
    static let LeftMeta = KeyModifier(rawValue: 0x40)
    static let RightMeta = KeyModifier(rawValue: 0x80)
}

enum ButtonState {
    case up, down
}

enum MouseButton {
    case none, left, middle, right
}

enum SuspendState {
    case willSuspend, didSuspend, willResume, didResume
}

enum Event {
    case axis(GamepadAxis)

    case char(UnicodeScalar)

    case exit

    case gamepad

    case key(KeyCode, KeyModifier, ButtonState)

    case mouse(x: UInt16, y: UInt16, z: Int32, button: MouseButton, state: ButtonState)

    case size(width: UInt16, height: UInt16)

    case window

    case suspend
}

class EventQueue {
    private let queue: Queue = Queue<Event>()
    
    func postSizeEvent(_ width: UInt16, height: UInt16) {
        queue.enqueue(Event.size(width: width, height: height))
    }
    
    func postMouseEvent(_ x: UInt16, y: UInt16, z: Int32, button: MouseButton = .none, state: ButtonState = .up) {
        queue.enqueue(Event.mouse(x: x, y: y, z: z, button: button, state: state))
    }
    
    func postKeyEvent(_ keyCode: KeyCode, modifier: KeyModifier, state: ButtonState) {
        queue.enqueue(Event.key(keyCode, modifier, state))
    }
    
    func postExitEvent() {
        queue.enqueue(Event.exit)
    }
    
    func poll() -> Event? {
        return queue.dequeue()
    }
}
