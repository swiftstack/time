// MARK: DurationConvertible

extension Timestamp: TimestampProtocol {}
extension Duration: TimestampProtocol {}

public protocol TimestampProtocol: CustomStringConvertible, Codable {
    var attoseconds: Int128 { get }

    var components: (seconds: Int64, attoseconds: Int64) { get }

    init(secondsComponent: Int64, attosecondsComponent: Int64)
}

extension Duration {
    public init(seconds: Int, nanoseconds: Int) {
        self.init(
            secondsComponent: Int64(seconds),
            attosecondsComponent: Int64(nanoseconds) * 1_000_000_000
        )
    }

    var nanoseconds: Int {
        Int(attoseconds / 1_000_000_000)
    }
}

extension Timestamp {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self = Self(try container.decode(Double.self))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(Double(self))
    }
}

extension TimestampProtocol {
    @inline(always)
    public var s: Int {
        ms / 1_000
    }

    @inline(always)
    public var ms: Int {
        us / 1_000
    }

    @inline(always)
    public var us: Int {
        ns / 1_000
    }

    @inline(always)
    public var ns: Int {
        Int(attoseconds / 1_000_000_000)
    }
}

extension IntegerLiteralType {
    public var s: Duration {
        return .init(seconds: self, nanoseconds: 0)
    }

    public var ms: Duration {
        return .init(seconds: self / 1_000, nanoseconds: self * 1_000_000)
    }

    public var us: Duration {
        return .init(seconds: self / 1_000_000, nanoseconds: self * 1_000)
    }

    public var ns: Duration {
        return .init(seconds: self / 1_000_000_000, nanoseconds: self)
    }
}

// MARK: Double

extension TimestampProtocol {
    @inlinable
    public init(_ double: Double) {
        let seconds = Int(double)
        let milliseconds = Int(double * 1_000 - Double(seconds) * 1_000)
        let nanoseconds = milliseconds * 1_000_000
        self.init(
            secondsComponent: Int64(seconds),
            attosecondsComponent: Int64(nanoseconds) * 1_000_000_000
        )
    }
}

extension Double {
    @inlinable
    public init<T: TimestampProtocol>(_ time: T) {
        self = Double(time.components.seconds) +
            Double(time.components.attoseconds / 1_000_000_000_000_000) / 1_000
    }
}

// MARK: description

extension TimestampProtocol {
    public var description: String {
        switch components.seconds {
        case 0:
            switch components.attoseconds {
            case 0..<1_000_000_000: 
                return "\(components.attoseconds) as"
            case 1_000_000_000..<1_000_000_000_000: 
                return "\(components.attoseconds / 1_000_000_000) ns"
            case 1_000_000_000_000..<1_000_000_000_000_000: 
                return "\(components.attoseconds / 1_000_000_000_000) μs"
            case 1_000_000_000_000_000...: 
                return "\(components.attoseconds / 1_000_000_000_000_000) ms"
            default:
                fatalError("unreachable")
            }
        default:
            let seconds = components.seconds
            let milliseconds = components.attoseconds / 1_000_000_000_000_000
            return "\(seconds).\(milliseconds) sec"
        }
    }
}
