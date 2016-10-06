import Foundation

// If I have done this right, this specific file has no
// dependencies other than Foundation

extension Date {
    /// returns DispatchTime after n floating point seconds
    public func dispatchTime(after seconds: Double) -> DispatchTime {
        let delay = Double(NSEC_PER_SEC) * seconds
        let nSec = DispatchTime.now().rawValue + UInt64(delay)
        return DispatchTime(uptimeNanoseconds: nSec)
    }
}

extension DateComponents {
    /// returns DispatchTime component offset from now
    public var dispatchTime: DispatchTime? {
        guard let offsetDate = Calendar.autoupdatingCurrent.date(byAdding: self, to: Date()) else { return nil }
        let seconds = offsetDate.timeIntervalSinceNow
        let delay = Double(NSEC_PER_SEC) * seconds
        let nSec = DispatchTime.now().rawValue + UInt64(delay)
        return DispatchTime(uptimeNanoseconds: nSec)
    }
}
