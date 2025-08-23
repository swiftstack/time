import Testing
import Platform
@testable import Time

@Test 
func now() {
    #expect(Time().ns != Time.now.ns)
    #expect(Time().seconds == Time.now.seconds)
    #expect(Time() > Time(seconds: 1523558109, nanoseconds: 0))
}

@Test 
func duration() {
    let duration: Time.Duration = 5.s
    let time: Time = .now

    let future = time + duration
    #expect(future.nanoseconds == time.nanoseconds)
    #expect(future.seconds == time.seconds + 5)
}

@Test 
func interval() {
    let location1: Time = .now
    let location2: Time = location1 + 2.s

    let interval = Time.Interval(location1, location2)
    #expect(interval.location == location1)
    #expect(interval.duration == 2.s)

    let interval1 = location1.interval(location2)
    #expect(interval1 == interval)

    let interval2 = location2.interval(location1)
    #expect(interval2 == interval)
}

@Test 
func equatable() {
    #expect(
        Time(seconds: 1, nanoseconds: 2)
        ==
        Time(seconds: 1, nanoseconds: 2))

    #expect(
        Time(seconds: 1, nanoseconds: 2)
        !=
        Time(seconds: 1, nanoseconds: 3))
}

@Test 
func description() {
    let seconds = Time(seconds: 123, nanoseconds: 123_000_000)
    #expect(seconds.description == "123.123 sec")

    let milliseconds = Time(seconds: 0, nanoseconds: 123_000_000)
    #expect(milliseconds.description == "123 ms")

    let microseconds = Time(seconds: 0, nanoseconds: 123_000)
    #expect(microseconds.description == "123 μs")

    let nanoseconds = Time(seconds: 0, nanoseconds: 123)
    #expect(nanoseconds.description == "123 ns")
}

@Test 
func double() {
    let duration = Time.Duration(seconds: 123, nanoseconds: 321_000_000)
    let timeInterval = Double(duration)
    #expect(timeInterval == 123.321)
    let original = Time.Duration(timeInterval)
    #expect(original == duration)
}

@Test 
func fromString() {
    let time = Time("12/04/18 18:26:32", format: "%d/%m/%y %T")
    #expect(time?.seconds == 1523557592)
    #expect(time?.nanoseconds == 0)
}
