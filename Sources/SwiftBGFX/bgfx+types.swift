// Copyright 2016 Stuart Carnie.
// License: https://github.com/stuartcarnie/SwiftBGFX#license-bsd-2-clause
//

import Cbgfx

/// Platform specific data, such as window handle and rendering context
public typealias PlatformData = bgfx_platform_data_t

/// Platform specific native window handle
public typealias NativeWindowHandle = UnsafeMutableRawPointer

/// Renderer statistics data
public struct Stats {

    /// CPU frame begin time
    public let cpuTimeBegin: UInt64

    /// CPU frame end time
    public let cpuTimeEnd: UInt64

    /// CPU timer frequency
    public let cpuTimeFreq: UInt64

    /// GPU frame begin time
    public let gpuTimeBegin: UInt64

    /// GPU frame end time
    public let gpuTimeEnd: UInt64

    /// GPU timer frequency
    public let gpuTimeFreq: UInt64

    init(stats: UnsafePointer<bgfx_stats_t>) {
        let v = stats.pointee
        cpuTimeBegin = v.cpuTimeBegin
        cpuTimeEnd = v.cpuTimeEnd
        cpuTimeFreq = v.cpuTimerFreq
        gpuTimeBegin = v.gpuTimeBegin
        gpuTimeEnd = v.gpuTimeEnd
        gpuTimeFreq = v.gpuTimerFreq
    }
}

