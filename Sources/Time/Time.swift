#if os(Linux)
import CTime
#endif
import Platform

public struct Timestamp: Equatable {
    // since 1970 ;)
    @usableFromInline
    var duration: Duration

    @inlinable
    public var attoseconds: Int128 {
        duration.attoseconds
    }

    @inlinable
    public var components: (seconds: Int64, attoseconds: Int64) {
        duration.components
    }

    @inlinable
    public init(secondsComponent: Int64, attosecondsComponent: Int64) {
        self.duration = .init(
            secondsComponent: secondsComponent,
            attosecondsComponent: attosecondsComponent
        )
    }
}

// MARK: reason

extension Timestamp {
    @inlinable
    public init() {
        let ts = timespec.now()
        self.init(
            seconds: .init(ts.tv_sec),
            nanoseconds: .init(ts.tv_nsec)
        )
    }

    @inlinable
    public init(seconds: Int, nanoseconds: Int) {
        self.duration = .init(
            secondsComponent: Int64(seconds),
            attosecondsComponent: Int64(nanoseconds) * 1_000_000_000
        )
    }

    @inlinable
    public static var now: Timestamp {
        return Timestamp()
    }

    @inlinable
    public static var distantFuture: Timestamp {
        return Timestamp(seconds: .max, nanoseconds: .max)
    }

    @inlinable
    public var timeIntervalSinceNow: Duration {
        self.duration - Timestamp.now.duration
    }
}

// MARK: from string

extension Timestamp {
    public init?(_ string: String, format: String) {
        var t = tm()
        guard strptime(string, format, &t) != nil else {
            return nil
        }
        let time = timegm(&t)
        guard time != -1 else {
            return nil
        }
        self.init(seconds: .init(time), nanoseconds: 0)
    }
}

// MARK: Comparable

extension Timestamp: Comparable {
    public static func < (lhs: Timestamp, rhs: Timestamp) -> Bool {
        lhs.duration < rhs.duration
    }
}

extension Timestamp {
    public static func < (lhs: Timestamp, rhs: timespec) -> Bool {
        lhs.duration < Timestamp(
            seconds: .init(rhs.tv_sec),
            nanoseconds: .init(rhs.tv_nsec)
        ).duration
    }
}

// MARK: arithmetic

extension Timestamp {
    public static func + (lhs: Timestamp, rhs: Duration) -> Timestamp {
        var timestamp = lhs
        timestamp.duration += rhs
        return timestamp
    }

    public static func - (lhs: Timestamp, rhs: Duration) -> Timestamp {
        var timestamp = lhs
        timestamp.duration -= rhs
        return timestamp
    }
}

extension Timestamp {
    static func - (lhs: Timestamp, rhs: Timestamp) -> Duration {
        lhs.duration - rhs.duration
    }
}
