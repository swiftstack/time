#if os(Linux)
import Platform

@_silgen_name("strptime")
func strptime(
    _ str: UnsafePointer<Int8>!,
    _ fmt: UnsafePointer<Int8>!,
    _ tm: UnsafeMutablePointer<tm>) -> UnsafeMutablePointer<Int8>!
#endif
