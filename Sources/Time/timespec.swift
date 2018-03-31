import Platform

extension timespec {
    @inline(__always)
    static func now() -> timespec {
        var ts = timespec()
        #if os(macOS) || os(iOS)
        _clock_gettime(&ts)
        #else
        clock_gettime(CLOCK_MONOTONIC, &ts)
        #endif
        return ts
    }

    #if os(macOS) || os(iOS)
    @inline(__always)
    static func _clock_gettime(_ ts: inout timespec)
    {
        if #available(OSX 10.12, *) {
            clock_gettime(CLOCK_MONOTONIC, &ts)
        } else {
            var info = mach_timebase_info_data_t()
            if info.numer == 0 || info.denom == 0 {
                mach_timebase_info(&info)
            }
            let time = mach_absolute_time() * UInt64(info.numer / info.denom)
            ts.tv_sec = Int(time / 1_000_000_000)
            ts.tv_nsec = Int(time % 1_000_000_000)
        }
    }
    #endif
}
