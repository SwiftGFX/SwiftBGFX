//
//  entry+osx.swift
//  bgfx Test
//
//  Created by Stuart Carnie on 4/19/16.
//  Copyright © 2016 SGC. All rights reserved.
//

import Foundation
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    
    var applicationHasTerminated = false
    
    func applicationDidFinishLaunching(notification: NSNotification) {
        print("did finish launching")
    }
    
    func applicationWillTerminate(notification: NSNotification) {
        self.applicationHasTerminated = true
    }
}

class WindowDelegate: NSObject, NSWindowDelegate {
    func windowCreated(window: NSWindow) {
        window.delegate = self
    }
    
    func windowShouldClose(sender: AnyObject) -> Bool {
        let win = sender as! NSWindow
        
        win.delegate = nil
        NSApp.terminate(self)
        return false
    }
    
    func windowDidResize(notification: NSNotification) {
        s_ctx.windowDidResize()
    }
}

@objc
class MainThreadEntry: NSObject {
    
    func execute() {
        runApp(sharedApp, argc: 0, argv: [])
    }
}

typealias ch = UnicodeScalar

extension UnicodeScalar {
    var toInt: Int {
        return Int(self.value)
    }
}

class Context {
    private var eventQueue: EventQueue = EventQueue()
    
    var translateKey = [KeyCode](count: 256, repeatedValue: .None)
    
    init() {
        translateKey[27] = .Esc
        translateKey[ch("\n").toInt] = .Return
        translateKey[ch("\t").toInt] = .Tab
        translateKey[127] = .Backspace
        translateKey[ch(" ").toInt] = .Space
        
        translateKey[ch("+").toInt] = .Plus
        translateKey[ch("=").toInt] = .Plus
        translateKey[ch("_").toInt] = .Minus
        translateKey[ch("-").toInt] = .Minus
        
        translateKey[ch("~").toInt] = .Tilde
        translateKey[ch("`").toInt] = .Tilde

        translateKey[ch(":").toInt] = .Semicolon
        translateKey[ch(";").toInt] = .Semicolon
        translateKey[ch("\"").toInt] = .Quote
        translateKey[ch("'").toInt] = .Quote
        
        translateKey[ch("{").toInt] = .LeftBracket
        translateKey[ch("[").toInt] = .LeftBracket
        translateKey[ch("}").toInt] = .RightBracket
        translateKey[ch("]").toInt] = .RightBracket

        translateKey[ch("<").toInt] = .Comma
        translateKey[ch(",").toInt] = .Comma
        translateKey[ch(">").toInt] = .Period
        translateKey[ch(".").toInt] = .Period
        translateKey[ch("?").toInt] = .Slash
        translateKey[ch("/").toInt] = .Slash
        translateKey[ch("|").toInt] = .Backslash
        translateKey[ch("\\").toInt] = .Backslash

        translateKey[ch("0").toInt] = .Key0
        translateKey[ch("1").toInt] = .Key1
        translateKey[ch("2").toInt] = .Key2
        translateKey[ch("3").toInt] = .Key3
        translateKey[ch("4").toInt] = .Key4
        translateKey[ch("5").toInt] = .Key5
        translateKey[ch("6").toInt] = .Key6
        translateKey[ch("7").toInt] = .Key7
        translateKey[ch("8").toInt] = .Key8
        translateKey[ch("9").toInt] = .Key9
        
        let a = ch("a").toInt
        let spc = ch(" ").toInt
        for char in a...ch("z").toInt {
            let v = char - a
            let k = KeyCode(rawValue: KeyCode.KeyA.rawValue + v)!
            translateKey[char] = k
            translateKey[char - spc] = k
        }
    }
    
    // mouse
    var mx: UInt16 = 0
    var my: UInt16 = 0
    var scroll: Int32 = 0
    var scrollf: CGFloat = 0.0
    
    var win: NSWindow!
    var winDelegate: WindowDelegate = WindowDelegate()
    
    func run() {
        NSApplication.sharedApplication()
        
        let dg = AppDelegate()
        NSApp.delegate = dg
        NSApp.setActivationPolicy(.Regular)
        NSApp.activateIgnoringOtherApps(true)
        NSApp.finishLaunching()
        
        NSNotificationCenter.defaultCenter()
            .postNotificationName(NSApplicationWillFinishLaunchingNotification, object: NSApp)
        NSNotificationCenter.defaultCenter()
            .postNotificationName(NSApplicationDidFinishLaunchingNotification, object: NSApp)
        
        let qmi = NSMenuItem(title: "Quit", action: #selector(NSApp.terminate), keyEquivalent: "q")
        
        let menu = NSMenu(title: "Example")
        menu.addItem(qmi)
        
        let appMenuItem = NSMenuItem()
        appMenuItem.submenu = menu
        
        let menuBar = NSMenu()
        menuBar.addItem(appMenuItem)
        NSApp.mainMenu = menuBar
        
        let rect = NSRect(x: 100, y: 100, width: 1280, height: 720)
        let style = NSTitledWindowMask | NSClosableWindowMask | NSResizableWindowMask | NSMiniaturizableWindowMask
        
        let win = NSWindow(contentRect: rect, styleMask: style, backing: .Buffered, defer: false)
        win.title = NSProcessInfo.processInfo().processName
        win.makeKeyAndOrderFront(nil)
        win.acceptsMouseMovedEvents = true
        win.backgroundColor = NSColor.blackColor()
        self.win = win
        winDelegate.windowCreated(win)
        
        
        var pd = PlatformData()
        pd.nwh = UnsafeMutablePointer(Unmanaged.passRetained(win).toOpaque())
        bgfx.setPlatformData(&pd)
        
        let mte = MainThreadEntry()
        let thread = NSThread(target: mte, selector: #selector(mte.execute), object: nil)
        thread.start()
        
        eventQueue.postSizeEvent(1280, height: 720)
        
        while !dg.applicationHasTerminated {
            if bgfx.renderFrame() == .Exiting {
                break
            }
            
            while dispatchEvent(peekEvent()) {}
        }
        
        eventQueue.postExitEvent()
        
        while bgfx.renderFrame() != .NoContext {}
        while !thread.finished {}
    }
    
    func poll() -> Event? {
        return eventQueue.poll()
    }
    
    func peekEvent() -> NSEvent? {
        return NSApp.nextEventMatchingMask(Int(NSEventMask.AnyEventMask.rawValue & 0xFFFF_FFFF),
                                           untilDate: NSDate.distantPast(),
                                           inMode: NSDefaultRunLoopMode,
                                           dequeue: true)
    }
    
    func updateMousePos()
    {
        let originalFrame = win.frame
        let location = win.mouseLocationOutsideOfEventStream
        let adjustFrame = win.contentRectForFrameRect(originalFrame)

        var x = location.x
        var y = adjustFrame.size.height - location.y
    
        // clamp within the range of the window
        if x < 0 {
            x = 0
        } else if x > adjustFrame.size.width {
            x = adjustFrame.size.width
        }
        
        if y < 0 {
            y = 0
        } else if y > adjustFrame.size.height {
            y = adjustFrame.size.height
        }

        mx = UInt16(x)
        my = UInt16(y)
    }
    
    func dispatchEvent(event: NSEvent?) -> Bool {
        guard let ev = event else {
            return false
        }
        
        print("event: \(ev)")
        
        switch ev.type {
        case .MouseMoved, .LeftMouseDragged, .RightMouseDragged, .OtherMouseDragged:
            updateMousePos()
            eventQueue.postMouseEvent(x: mx, y: my, z: scroll)
            
        case .LeftMouseDown:
            eventQueue.postMouseEvent(x: mx, y: my, z: scroll, button: .Left, state: .Down)
            
        case .LeftMouseUp:
            eventQueue.postMouseEvent(x: mx, y: my, z: scroll, button: .Left, state: .Up)
            
        case .RightMouseDown:
            eventQueue.postMouseEvent(x: mx, y: my, z: scroll, button: .Right, state: .Down)
            
        case .RightMouseUp:
            eventQueue.postMouseEvent(x: mx, y: my, z: scroll, button: .Right, state: .Up)
            
        case .OtherMouseDown:
            eventQueue.postMouseEvent(x: mx, y: my, z: scroll, button: .Middle, state: .Down)
            
        case .OtherMouseUp:
            eventQueue.postMouseEvent(x: mx, y: my, z: scroll, button: .Middle, state: .Up)
            
        case .ScrollWheel:
            scrollf += ev.deltaY
            scroll = Int32(scrollf)
            eventQueue.postMouseEvent(x: mx, y: my, z: scroll)
            
        case .KeyDown:
            let (key, modifiers, _) = handleKeyEvent(ev)
            if key == .None {
                break
            }
            
            switch key {
            case .KeyQ where modifiers.contains(.RightMeta):
                eventQueue.postExitEvent()
                
            default:
                eventQueue.postKeyEvent(key, modifier: modifiers, state: .Down)
                return false
            }
            
        case .KeyUp:
            let (key, modifiers, _) = handleKeyEvent(ev)
            if key == .None {
                break
            }
            
            eventQueue.postKeyEvent(key, modifier: modifiers, state: .Up)
            return false
            
        default:
            break;
        }
        
        NSApp.sendEvent(ev)
        NSApp.updateWindows()
        
        return true
    }
    
    func handleKeyEvent(ev: NSEvent) -> (KeyCode, KeyModifier, UnicodeScalar) {
        guard let key = ev.charactersIgnoringModifiers else {
            return (.None, .None, "\u{0}")
        }
        
        let keyNum = key.unicodeScalars.first!
        let mod = translateModifiers(ev.modifierFlags)
        
        var keyCode: KeyCode
        if keyNum.toInt < 256 {
            keyCode = translateKey[keyNum.toInt]
        } else {
            
            switch Int(ev.keyCode) {
                
            case NSF1FunctionKey: keyCode = .F1
            case NSF2FunctionKey: keyCode = .F2
            case NSF3FunctionKey: keyCode = .F3
            case NSF4FunctionKey: keyCode = .F4
            case NSF5FunctionKey: keyCode = .F5
            case NSF6FunctionKey: keyCode = .F6
            case NSF7FunctionKey: keyCode = .F7
            case NSF8FunctionKey: keyCode = .F8
            case NSF9FunctionKey: keyCode = .F9
            case NSF10FunctionKey: keyCode = .F10
            case NSF11FunctionKey: keyCode = .F11
            case NSF12FunctionKey: keyCode = .F12

            case NSLeftArrowFunctionKey: keyCode = .Left
            case NSRightArrowFunctionKey: keyCode = .Right
            case NSUpArrowFunctionKey: keyCode = .Up
            case NSDownArrowFunctionKey: keyCode = .Down

            case NSPageUpFunctionKey: keyCode = .PageUp
            case NSPageDownFunctionKey: keyCode = .PageDown
            case NSHomeFunctionKey: keyCode = .Home
            case NSEndFunctionKey: keyCode = .End
                
            case NSPrintScreenFunctionKey: keyCode = .Print

            default:
                keyCode = .None
            }
        }
        
        return (keyCode, mod, keyNum)
    }
    
    func translateModifiers(flags: NSEventModifierFlags) -> KeyModifier {
        var mk = KeyModifier()
        
        if flags.contains(.ShiftKeyMask) {
            mk.insert(.LeftShift)
            mk.insert(.RightShift)
        }
        
        if flags.contains(.AlternateKeyMask) {
            mk.insert(.LeftAlt)
            mk.insert(.RightAlt)
        }

        if flags.contains(.ControlKeyMask) {
            mk.insert(.LeftCtrl)
            mk.insert(.RightCtrl)
        }

        if flags.contains(.CommandKeyMask) {
            mk.insert(.LeftMeta)
            mk.insert(.RightMeta)
        }

        return mk
    }
    
    func windowDidResize() {
        let originalFrame = win.frame
        let rect = win.contentRectForFrameRect(originalFrame)
        let width = UInt16(rect.size.width)
        let height = UInt16(rect.size.height)
        eventQueue.postSizeEvent(width, height: height)
        
        // make sure both mouse button states are .Up
        eventQueue.postMouseEvent(x: mx, y: my, z: scroll, button: .Left, state: .Up)
        eventQueue.postMouseEvent(x: mx, y: my, z: scroll, button: .Right, state: .Up)
    }
}

var s_ctx: Context = Context()

func main() {
    s_ctx.run()
}