// MARK: DurationConvertible

extension Time: TimeProtocol{}
extension Time.Duration: TimeProtocol{}

public protocol TimeProtocol {
    var seconds: Int { get }
    var nanoseconds: Int { get }

    init(seconds: Int, nanoseconds: Int)
}

extension TimeProtocol {
    public var s: Int {
        return seconds
    }

    public var ms: Int {
        return seconds * 1_000 + nanoseconds / 1_000_000
    }

    public var us: Int {
        return seconds * 1_000_000 + nanoseconds / 1_000
    }

    public var ns: Int {
        return seconds * 1_000_000_000 + nanoseconds
    }
}

extension IntegerLiteralType {
    public var s: Time.Duration {
        return .init(seconds: self, nanoseconds: 0)
    }

    public var ms: Time.Duration {
        return .init(seconds: self / 1_000, nanoseconds: self * 1_000_000)
    }

    public var us: Time.Duration {
        return .init(seconds: self / 1_000_000, nanoseconds: self * 1_000)
    }

    public var ns: Time.Duration {
        return .init(seconds: self / 1_000_000_000, nanoseconds: self)
    }
}

// MARK: Double

extension TimeProtocol {
    public init(_ double: Double) {
        let seconds = Int(double)
        let milliseconds = Int(double * 1_000 - Double(seconds) * 1_000)
        let nanoseconds = milliseconds * 1_000_000
        self.init(seconds: seconds, nanoseconds: nanoseconds)
    }
}

extension Double {
    public init(_ interval: Time.Interval) {
        self.init(interval.duration)
    }

    public init(_ duration: Time.Duration) {
        self = Double(duration.seconds) +
            Double(duration.nanoseconds / 1_000_000) / 1_000
    }
}
