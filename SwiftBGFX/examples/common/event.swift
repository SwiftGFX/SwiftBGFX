//
//  event.swift
//  bgfx Test
//
//  Created by Stuart Carnie on 4/19/16.
//  Copyright © 2016 SGC. All rights reserved.
//

public enum GamepadAxis {
    case LeftX, LeftY, LeftZ, RightX, RightY, RightZ
}

public enum KeyCode: Int32 {
    case None
    
    case Esc, Return, Tab, Space, Backspace
    case Up, Down, Left, Right
    case Insert, Delete, Home, End, PageUp, PageDown
    case Print
    
    case Plus, Minus, LeftBracket, RightBracket, Semicolon
    case Quote, Comma, Period, Slash, Backslash, Tilde
    
    case F1, F2, F3, F4, F5, F6, F7, F8, F9, F10, F11, F12
    
    case NumPad0, NumPad1, NumPad2, NumPad3, NumPad4
    case NumPad5, NumPad6, NumPad7, NumPad8, NumPad9
    
    case Key0, Key1, Key2, Key3, Key4, Key5, Key6, Key7, Key8, Key9
    
    case KeyA, KeyB, KeyC, KeyD, KeyE, KeyF, KeyG, KeyH
    case KeyI, KeyJ, KeyK, KeyL, KeyM, KeyN, KeyO, KeyP
    case KeyQ, KeyR, KeyS, KeyT, KeyU, KeyV, KeyW, KeyX
    case KeyY, KeyZ
    
    case GamepadA, GamepadB, GamepadX, GamepadY, GamepadThumbL, GamepadThumbR
    case GamepadShoulderL, GamepadShoulderR, GamepadUp, GamepadDown, GamepadLeft
    case GamepadRight, GamepadBack, GamepadStart, GamepadGuide
}

public struct KeyModifier : OptionSetType {
    public let rawValue: UInt8
    public init(rawValue: UInt8) { self.rawValue = rawValue }
    
    public static let None = KeyModifier(rawValue: 0x00)
    public static let LeftAlt = KeyModifier(rawValue: 0x01)
    public static let RightAlt = KeyModifier(rawValue: 0x02)
    public static let LeftCtrl = KeyModifier(rawValue: 0x04)
    public static let RightCtrl = KeyModifier(rawValue: 0x08)
    public static let LeftShift = KeyModifier(rawValue: 0x10)
    public static let RightShift = KeyModifier(rawValue: 0x20)
    public static let LeftMeta = KeyModifier(rawValue: 0x40)
    public static let RightMeta = KeyModifier(rawValue: 0x80)
}

public enum ButtonState {
    case Up, Down
}

public enum MouseButton {
    case None, Left, Middle, Right
}

public enum SuspendState {
    case WillSuspend, DidSuspend, WillResume, DidResume
}

public enum Event {
    case Axis(GamepadAxis)
    
    case Char(UnicodeScalar)
    
    case Exit
    
    case Gamepad
    
    case Key(KeyCode, KeyModifier, ButtonState)
    
    case Mouse(x: UInt16, y: UInt16, z: Int32, button: MouseButton, state: ButtonState)
    
    case Size(width: UInt16, height: UInt16)
    
    case Window
    
    case Suspend
}

public class EventQueue {
    private let queue: Queue = Queue<Event>()
    
    func postSizeEvent(width: UInt16, height: UInt16) {
        queue.enqueue(Event.Size(width: width, height: height))
    }
    
    func postMouseEvent(x x: UInt16, y: UInt16, z: Int32, button: MouseButton = .None, state: ButtonState = .Up) {
        queue.enqueue(Event.Mouse(x: x, y: y, z: z, button: button, state: state))
    }
    
    func postKeyEvent(keyCode: KeyCode, modifier: KeyModifier, state: ButtonState) {
        queue.enqueue(Event.Key(keyCode, modifier, state))
    }
    
    func postExitEvent() {
        queue.enqueue(Event.Exit)
    }
    
    func poll() -> Event? {
        return queue.dequeue()
    }
}