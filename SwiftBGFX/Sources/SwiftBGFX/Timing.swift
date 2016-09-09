// Copyright 2016 Stuart Carnie.
// License: https://github.com/stuartcarnie/SwiftBGFX#license-bsd-2-clause
//

#if os(OSX) || os(tvOS) || os(iOS)
	import Darwin

    public class Timing {
        
        public static var counter: UInt64 {
            return mach_absolute_time()
        }
        
        public static let frequency: UInt64 = {
            var info = mach_timebase_info_data_t()
            mach_timebase_info(&info)
            return 0
        }()
    }
#else
#endif

public struct Counter {
    private var base: UInt64
    
    public init() {
        base = Timing.counter
    }
    
    public var counter: Double {
        return Double(Timing.counter - base) / 1_000_000_000.0 // nanoseconds
    }
    
    public mutating func reset() {
        base = Timing.counter
    }
}
