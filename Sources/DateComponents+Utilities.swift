import Foundation

// Acknowlegements in Date+Utilities.swift

// Subscripting
extension DateComponents {
    /// Adds date component subscripting
    public subscript(component: Calendar.Component) -> Int? {
        switch component {
        case .era: return self.era
        case .year: return self.year
        case .month: return self.month
        case .day: return self.day
        case .hour: return self.hour
        case .minute: return self.minute
        case .second: return self.second
        case .weekday: return self.weekday
        case .weekdayOrdinal: return self.weekdayOrdinal
        case .quarter: return self.quarter
        case .weekOfMonth: return self.weekOfMonth
        case .weekOfYear: return self.weekOfYear
        case .yearForWeekOfYear: return self.yearForWeekOfYear
        case .nanosecond: return self.nanosecond
        // case .calendar: return self.calendar
        // case .timeZone: return self.timeZone
        default: return nil
        }
    }
}

// Members
extension DateComponents {
    /// Returns the Int-bearing Calendar.Component members
    /// that make up the date
    public var members: Set<Calendar.Component> {
        var components: Set<Calendar.Component> = []
        if let _ = era { components.insert(.era) }
        if let _ = year { components.insert(.year) }
        if let _ = month { components.insert(.month) }
        if let _ = day { components.insert(.day) }
        if let _ = hour { components.insert(.hour) }
        if let _ = minute { components.insert(.minute) }
        if let _ = second { components.insert(.second) }
        if let _ = weekday { components.insert(.weekday) }
        if let _ = weekdayOrdinal { components.insert(.weekdayOrdinal) }
        if let _ = quarter { components.insert(.quarter) }
        if let _ = weekOfMonth { components.insert(.weekOfMonth) }
        if let _ = weekOfYear { components.insert(.weekOfYear) }
        if let _ = yearForWeekOfYear { components.insert(.yearForWeekOfYear) }
        if let _ = nanosecond { components.insert(.nanosecond) }
        // if let calendar = calendar { set.insert(.calendar) }
        // if let timeZone = timeZone { set.insert(.timeZone) }
        return components
    }
}

/// Standardization
extension DateComponents {
    /// Returns copy with zero-valued components removed
    public var trimmed: DateComponents {
        var copy = DateComponents()
        for component in members {
            guard let value = value(for: component) else { continue }
            if value != 0 { copy.setValue(value, for: component) }
        }
        return copy
    }
    
    /// Returns a copy with normalized (positive) values
    public var normalized: DateComponents {
        let referenceDate = Date(timeIntervalSinceReferenceDate: 0)
        guard let adjusted = Date.sharedCalendar.date(byAdding: self, to: referenceDate) else { return self }
        let copy = NSCalendar.current.dateComponents(Date.commonComponents, from: referenceDate, to: adjusted)
        return copy.trimmed
    }
    
    /// Representation of the date components difference as a time interval
    public var timeInterval: TimeInterval {
        let referenceDate = Date(timeIntervalSinceReferenceDate: 0)
        guard let adjusted = Date.sharedCalendar.date(byAdding: self, to: referenceDate) else { return 0 }
        return adjusted.timeIntervalSinceReferenceDate
    }
}

/// Component Math
extension DateComponents {
    
    /// Add two date components together
    static public func +(lhs: DateComponents, rhs: DateComponents) -> DateComponents {
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
    static public func -(lhs: DateComponents, rhs: DateComponents) -> DateComponents {
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

/// Component Presentation
extension DateComponents {
    /// Component Presentation Styles
    public enum PresentationStyle { case standard, relative, approximate }
    
    /// Returns a string representation of the date components
    public func description(
        units: DateComponentsFormatter.UnitsStyle = .full,
        remaining: Bool = false,
        approximate: Bool = false,
        style: PresentationStyle = .standard
        ) -> String {
        let formatter = DateComponentsFormatter()
        formatter.calendar = Date.sharedCalendar
        formatter.unitsStyle = units
        formatter.includesTimeRemainingPhrase = remaining
        formatter.includesApproximationPhrase = approximate
        
        /// Caution: Use relative presentation only when all
        /// component signs are uniform. Use 'normalize' to
        /// normalize the component.        
        if style == .relative {
            guard var string = formatter.string(from: self) else { return "\(self)" }
            if let newTime = Date.sharedCalendar.date(byAdding: self, to: Date()) {
                if newTime.isFuture { string += " from now" }
                else if newTime.isPast { string += " ago" }
            }
            return string
        }
        
        if style == .approximate {
            let ti = abs(self.timeInterval)
            if ti < 3 { return "just now" }
            var string = ""
            if ti < Date.minute { string = "\(lrint(ti)) seconds" }
            else if abs(ti - Date.minute) <= 3.seconds { string = "a minute" }
            else if ti < Date.hour { string = "\(lrint(ti / Date.minute)) minutes" }
            else if abs(ti - Date.hour) <= (30.minutes) { string = "an hour" }
            else if ti < Date.day { string = "\(lrint(ti / Date.hour)) hours" }
            else if abs(ti - Date.day) <= (12.hours) { string = "a day" }
            else if ti < Date.week { string = "\(lrint(ti / Date.day)) days" }
            else { string = "\(lrint(ti / (Date.week))) weeks" }
            if let newTime = Date.sharedCalendar.date(byAdding: self, to: Date()) {
                if newTime.isFuture { string += " from now" }
                else if newTime.isPast { string += " ago" }
            }
            return string
        }
        
        guard let string = formatter.string(from: self)
            else { return "\(self)" }
        return string
    }
}

// Alternative offset approach that constructs date components for offset duty
// I find this more verbose, less readable, less functional but your mileage may vary
extension DateComponents {
    /// Returns components populated by n years
    public static func years(_ count: Int) -> DateComponents { return DateComponents(year: count) }
    /// Returns components populated by n months
    public static func months(_ count: Int) -> DateComponents { return DateComponents(month: count) }
    /// Returns components populated by n days
    public static func days(_ count: Int) -> DateComponents { return DateComponents(day: count) }
    /// Returns components populated by n hours
    public static func hours(_ count: Int) -> DateComponents { return DateComponents(hour: count) }
    /// Returns components populated by n minutes
    public static func minutes(_ count: Int) -> DateComponents { return DateComponents(minute: count) }
    /// Returns components populated by n seconds
    public static func seconds(_ count: Int) -> DateComponents { return DateComponents(second: count) }
    /// Returns components populated by n nanoseconds
    public static func nanoseconds(_ count: Int) -> DateComponents { return DateComponents(nanosecond: count) }
}
