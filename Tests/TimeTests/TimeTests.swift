import Test
@testable import Time

final class TimeTests: TestCase {
    func testNow() {
	    expect(Time() != .now)
        expect(Time().seconds == Time.now.seconds)
        expect(Time() > Time(seconds: 1523558109, nanoseconds: 0))
    }

    func testDuration() {
        let duration: Time.Duration = 5.s
        let time: Time = .now

        let future = time + duration
        expect(future.nanoseconds == time.nanoseconds)
        expect(future.seconds == time.seconds + 5)
    }

    func testInterval() {
        let location1: Time = .now
        let location2: Time = location1 + 2.s

        let interval = Time.Interval(location1, location2)
        expect(interval.location == location1)
        expect(interval.duration == 2.s)

        let interval1 = location1.interval(location2)
        expect(interval1 == interval)

        let interval2 = location2.interval(location1)
        expect(interval2 == interval)
    }

    func testEquatable() {
        expect(
            Time(seconds: 1, nanoseconds: 2)
            ==
            Time(seconds: 1, nanoseconds: 2))

        expect(
            Time(seconds: 1, nanoseconds: 2)
            !=
            Time(seconds: 1, nanoseconds: 3))
    }

    func testDescription() {
        let seconds = Time(seconds: 123, nanoseconds: 123_000_000)
        expect(seconds.description == "123.123 sec")

        let milliseconds = Time(seconds: 0, nanoseconds: 123_000_000)
        expect(milliseconds.description == "123 ms")

        let microseconds = Time(seconds: 0, nanoseconds: 123_000)
        expect(microseconds.description == "123 μs")

        let nanoseconds = Time(seconds: 0, nanoseconds: 123)
        expect(nanoseconds.description == "123 ns")
    }

    func testDouble() {
        let duration = Time.Duration(seconds: 123, nanoseconds: 321_000_000)
        let timeInterval = Double(duration)
        expect(timeInterval == 123.321)
        let original = Time.Duration(timeInterval)
        expect(original == duration)
    }

    func testFromString() {
        let time = Time("12/04/18 18:26:32", format: "%d/%m/%y %T")
        expect(time?.seconds == 1523557592)
        expect(time?.nanoseconds == 0)
    }
}
