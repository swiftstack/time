// MARK: DurationConvertible

extension Time: TimeProtocol{}
extension Time.Duration: TimeProtocol{}

public protocol TimeProtocol: CustomStringConvertible, Codable {
    var seconds: Int { get }
    var nanoseconds: Int { get }

    init(seconds: Int, nanoseconds: Int)
}

extension TimeProtocol {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self = Self(try container.decode(Double.self))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(Double(self))
    }
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
    @inlinable
    public init(_ double: Double) {
        let seconds = Int(double)
        let milliseconds = Int(double * 1_000 - Double(seconds) * 1_000)
        let nanoseconds = milliseconds * 1_000_000
        self.init(seconds: seconds, nanoseconds: nanoseconds)
    }
}

extension Double {
    @inlinable
    public init(_ interval: Time.Interval) {
        self.init(interval.duration)
    }

    @inlinable
    public init<T: TimeProtocol>(_ time: T) {
        self = Double(time.seconds) +
            Double(time.nanoseconds / 1_000_000) / 1_000
    }
}

// MARK: description

extension TimeProtocol {
    public var description: String {
        switch seconds {
        case 0:
            switch nanoseconds {
            case 0..<1_000: return "\(nanoseconds) ns"
            case 1_000..<1_000_000: return "\(nanoseconds / 1_000) μs"
            case 1_000_000...: return "\(nanoseconds / 1_000_000) ms"
            default: fatalError("unreachable")
            }
        default:
            return "\(seconds).\(nanoseconds / 1_000_000) sec"
        }
    }
}
