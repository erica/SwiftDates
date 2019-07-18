import Foundation

// If I have done this right, this specific file has no
// dependencies other than Foundation


extension DispatchTimeInterval {
    /// Returns a dispatch time interval in nanoseconds from a
    /// `Double` number of seconds
    ///
    /// ```
    /// let timeInEightAndHalf: DispatchTime = .now() + .seconds(8.5)
    /// ```
    ///
    /// - Reference: http://ericasadun.com/2017/05/23/5-easy-dispatch-tricks/
    public static func seconds(_ amount: Double) -> DispatchTimeInterval {
        let delay = Double(NSEC_PER_SEC) * amount
        return DispatchTimeInterval.nanoseconds(Int(delay))
    }
}

extension DispatchTime {
    /// Returns a dispatch time offset by `duration` seconds from `now`
    ///
    /// ```
    /// DispatchQueue.main.asyncAfter(deadline: .secondsFromNow($0)) {...}
    /// ```
    ///
    /// - Reference: http://ericasadun.com/2017/05/23/5-easy-dispatch-tricks/
    public static func secondsFromNow(_ duration: Double) -> DispatchTime {
        return DispatchTime.now() + duration
    }
}

extension DateComponents {
    /// Returns a DispatchTime that's been component offset from now
    public var dispatchTime: DispatchTime? {
        guard let offsetDate = Calendar.autoupdatingCurrent.date(byAdding: self, to: Date()) else { return nil }
        let seconds = offsetDate.timeIntervalSinceNow
        return DispatchTime.now() + seconds
    }
}
