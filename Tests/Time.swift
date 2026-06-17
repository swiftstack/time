import Testing
import Platform
@testable import Time

@Test 
func now() {
    #expect(Timestamp().ns != Timestamp.now.ns)
    #expect(Timestamp().components.seconds == Timestamp.now.components.seconds)
    #expect(Timestamp() > Timestamp(seconds: 1523558109, nanoseconds: 0))
}

@Test 
func duration() {
    let duration: Duration = 5.s
    let time: Timestamp = .now

    let future = time + duration
    #expect(future.components.attoseconds == time.components.attoseconds)
    #expect(future.components.seconds == time.components.seconds + 5)
}

@Test 
func equatable() {
    #expect(
        Timestamp(seconds: 1, nanoseconds: 2)
        ==
        Timestamp(seconds: 1, nanoseconds: 2))

    #expect(
        Timestamp(seconds: 1, nanoseconds: 2)
        !=
        Timestamp(seconds: 1, nanoseconds: 3))
}

@Test 
func description() {
    let seconds = Timestamp(seconds: 123, nanoseconds: 123_000_000)
    #expect(seconds.description == "123.123 sec")

    let milliseconds = Timestamp(seconds: 0, nanoseconds: 123_000_000)
    #expect(milliseconds.description == "123 ms")

    let microseconds = Timestamp(seconds: 0, nanoseconds: 123_000)
    #expect(microseconds.description == "123 μs")

    let nanoseconds = Timestamp(seconds: 0, nanoseconds: 123)
    #expect(nanoseconds.description == "123 ns")

    let attoseconds = Timestamp(secondsComponent: 0, attosecondsComponent: 123)
    #expect(attoseconds.description == "123 as")
}

@Test 
func double() {
    let duration = Duration(seconds: 123, nanoseconds: 321_000_000)
    let timeInterval = Double(duration)
    #expect(timeInterval == 123.321)
    let original = Duration(timeInterval)
    #expect(original == duration)
}

@Test 
func fromString() {
    let time = Timestamp("12/04/18 18:26:32", format: "%d/%m/%y %T")
    #expect(time?.components.seconds == 1523557592)
    #expect(time?.components.attoseconds == 0)
}
