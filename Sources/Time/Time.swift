#if os(Linux)
import CTime
#endif
import Platform

public struct Time {
    public var seconds: Int
    public var nanoseconds: Int

    public init(seconds: Int, nanoseconds: Int) {
        self.seconds = seconds
        self.nanoseconds = nanoseconds
    }

    public struct Duration {
        public var seconds: Int
        public var nanoseconds: Int

        public init(seconds: Int, nanoseconds: Int) {
            self.seconds = seconds
            self.nanoseconds = nanoseconds
        }
    }

    public struct Interval {
        public let location: Time
        public let duration: Duration

        public init(location: Time, duration: Duration) {
            self.location = location
            self.duration = duration
        }
    }
}

extension Time {
    public init() {
        let ts = timespec.now()
        self.seconds = ts.tv_sec
        self.nanoseconds = ts.tv_nsec
    }

    public static var now: Time {
        return Time()
    }

    public static var distantFuture: Time {
        return Time(seconds: Int.max, nanoseconds: Int.max)
    }

    public var timeIntervalSinceNow: Time.Interval {
            return interval(Time())
    }

    public func interval(_ location: Time) -> Interval {
        return Interval(self, location)
    }
}

extension Time.Interval {
    public init(_ point1: Time, _ point2: Time) {
        switch point1 < point2 {
        case true: self.init(location: point1, duration: point2 - point1)
        case false: self.init(location: point2, duration: point1 - point2)
        }
    }
}

// MARK: from string

extension Time {
    public init?(_ string: String, format: String) {
        var t = tm()
        guard strptime(string, format, &t) != nil else {
            return nil
        }
        let time = timegm(&t)
        guard time != -1 else {
            return nil
        }
        self.init(seconds: time, nanoseconds: 0)
    }
}

// MARK: Equatable

extension Time: Equatable {
    public static func == (lhs: Time, rhs: Time) -> Bool {
        return lhs.seconds == rhs.seconds && lhs.nanoseconds == rhs.nanoseconds
    }
}

extension Time.Duration: Equatable {
    public static func == (lhs: Time.Duration, rhs: Time.Duration) -> Bool {
        return lhs.seconds == rhs.seconds && lhs.nanoseconds == rhs.nanoseconds
    }
}

extension Time.Interval: Equatable {
    public static func == (lhs: Time.Interval, rhs: Time.Interval) -> Bool {
        return lhs.location == rhs.location && lhs.duration == rhs.duration
    }
}

// MARK: Comparable

extension Time: Comparable {
    public static func < (lhs: Time, rhs: Time) -> Bool {
        switch lhs.seconds < rhs.seconds {
        case true: return true
        case false where lhs.seconds > rhs.seconds: return false
        default: return lhs.nanoseconds < rhs.nanoseconds
        }
    }
}

extension Time {
    public static func < (lhs: Time, rhs: timespec) -> Bool {
        switch lhs.seconds < rhs.tv_sec {
        case true: return true
        case false where lhs.seconds > rhs.tv_sec: return false
        default: return lhs.nanoseconds < rhs.tv_nsec
        }
    }
}

// MARK: arithmetic

extension Time {
    public static func + (lhs: Time, rhs: Time.Duration) -> Time {
        var result = Time(seconds: 0, nanoseconds: 0)
        if lhs.nanoseconds + rhs.nanoseconds >= 1_000_000_000 {
            result.seconds = lhs.seconds + rhs.seconds + 1
            result.nanoseconds = lhs.nanoseconds + rhs.nanoseconds - 1000000000
        } else {
            result.seconds = lhs.seconds + rhs.seconds
            result.nanoseconds = lhs.nanoseconds + rhs.nanoseconds
        }
        return result
    }

    public static func - (lhs: Time, rhs: Time.Duration) -> Time {
        var result = Time()
        if lhs.nanoseconds - rhs.nanoseconds < 0 {
            result.seconds = lhs.seconds - rhs.seconds - 1
            result.nanoseconds = lhs.nanoseconds - rhs.nanoseconds + 1000000000
        } else {
            result.seconds = lhs.seconds - rhs.seconds
            result.nanoseconds = lhs.nanoseconds - rhs.nanoseconds
        }
        return result
    }
}

extension Time {
    static func - (lhs: Time, rhs: Time) -> Time.Duration {
        precondition(lhs >= rhs)
        let time = lhs - Duration(
            seconds: rhs.seconds,
            nanoseconds: rhs.nanoseconds)
        return Time.Duration(
            seconds: time.seconds,
            nanoseconds: time.nanoseconds)
    }
}
