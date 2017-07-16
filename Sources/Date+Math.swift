import Foundation

/*
 Note: These items are meant for simple utility. Pay attention
 to the cautions regarding Calendar.Component use.
 
 Acknowlegements in Date+Utilities.swift
 */

/// Standard interval reference
/// Not meant to replace `offset(_: Calendar.Component, _: Int)` to offset dates
public extension Date {
    /// Returns number of seconds per second
    public static let second: TimeInterval = 1
    /// Returns number of seconds per minute
    public static let minute: TimeInterval = 60
    /// Returns number of seconds per hour
    public static let hour: TimeInterval = 3600
    /// Returns number of seconds per 24-hour day
    public static let day: TimeInterval = 86400
    /// Returns number of seconds per standard week
    public static let week: TimeInterval = 604800
}

/// Utility for interval math
/// Not meant to replace `offset(_: Calendar.Component, _: Int)` to offset dates
public extension Int {
    /// Returns number of seconds in n seconds
    public var seconds: TimeInterval { return TimeInterval(self) * Date.second }
    /// Returns number of seconds in n minutes
    public var minutes: TimeInterval { return TimeInterval(self) * Date.minute }
    /// Returns number of seconds in n hours
    public var hours: TimeInterval { return TimeInterval(self) * Date.hour }
    /// Returns number of seconds in n 24-hour days
    public var days: TimeInterval { return TimeInterval(self) * Date.day }
    /// Returns number of seconds in n standard weeks
    public var weeks: TimeInterval { return TimeInterval(self) * Date.week }
}

/// Calendar component offsets
extension Date {
    /// Performs calendar math using date components as alternative
    /// to `offset(_: Calendar.Component, _: Int)`
    /// e.g.
    /// ```swift
    /// print((Date() + DateComponents.days(3) + DateComponents.hours(1)).fullString)
    /// ```
    public static func +(lhs: Date, rhs: DateComponents) -> Date {
        return Date.sharedCalendar.date(byAdding: rhs, to: lhs)! // yes force unwrap. sue me.
    }
}

/// Component Math
extension DateComponents {
    
    /// Add two date components together
    public static func + (lhs: DateComponents, rhs: DateComponents) -> DateComponents {
        var copy = DateComponents()
        for component in lhs.members.union(rhs.members) {
            var sum = 0
            // Error workaround where instead of returning nil
            // the values return Int.max
            if let value = lhs.value(for: component),
                value != Int.max, value != Int.min
            { sum = sum + value }
            if let value = rhs.value(for: component),
                value != Int.max, value != Int.min
            { sum = sum + value }
            copy.setValue(sum, for: component)
        }
        return copy
    }
    
    /// Subtract date components
    public static func - (lhs: DateComponents, rhs: DateComponents) -> DateComponents {
        var copy = DateComponents()
        for component in lhs.members.union(rhs.members) {
            var result = 0
            // Error workaround where instead of returning nil
            // the values return Int.max
            if let value = lhs.value(for: component),
                value != Int.max, value != Int.min
            { result = result + value }
            if let value = rhs.value(for: component),
                value != Int.max, value != Int.min
            { result = result - value }
            copy.setValue(result, for: component)
        }
        return copy
    }
}


extension Date {
    /// Returns the common components separating the
    /// the date on the lhs from the date on the rhs.
    /// For example `laterDate - earlierDate`
    public static func - (lhs: Date, rhs: Date) -> DateComponents {
        return Date.sharedCalendar.dateComponents(commonComponents, from: rhs, to: lhs)
    }
}

