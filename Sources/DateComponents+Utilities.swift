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

// For Frederic B
// e.g. let dc = DateComponents(ti: 1.weeks + 1.days + 3.hours + 5.minutes + 4.seconds)
extension DateComponents {
    public init(ti: TimeInterval) {
        var ti = floor(ti)
        let seconds = lrint(ti.truncatingRemainder(dividingBy: 1.minutes))
        ti -= seconds.seconds
        let minutes = lrint(ti.truncatingRemainder(dividingBy: 1.hours) / 1.minutes)
        ti -= minutes.minutes
        let hours = lrint(ti.truncatingRemainder(dividingBy: 1.days) / 1.hours)
        ti -= hours.hours
        let days = lrint(ti / 1.days)
        self.init(day: days, hour: hours, minute: minutes, second: seconds)
    }
}

// Members
extension DateComponents {
    /// Returns the Int-bearing Calendar.Component members
    /// that make up the date
    public var members: Set<Calendar.Component> {
        
        // See bug https://bugs.swift.org/browse/SR-2671
        // Error workaround where instead of returning nil
        // the values return Int.max
        func validateMember(_ value: Int?) -> Bool {
            guard let value = value, value != Int.max, value != Int.min
                else { return false }
            return true
        }
        
        var components: Set<Calendar.Component> = []
        if validateMember(era) { components.insert(.era) }
        if validateMember(year) { components.insert(.year) }
        if validateMember(month) { components.insert(.month) }
        if validateMember(day) { components.insert(.day) }
        if validateMember(hour) { components.insert(.hour) }
        if validateMember(minute) { components.insert(.minute) }
        if validateMember(second) { components.insert(.second) }
        if validateMember(weekday) { components.insert(.weekday) }
        if validateMember(weekdayOrdinal) { components.insert(.weekdayOrdinal) }
        if validateMember(quarter) { components.insert(.quarter) }
        if validateMember(weekOfMonth) { components.insert(.weekOfMonth) }
        if validateMember(weekOfYear) { components.insert(.weekOfYear) }
        if validateMember(yearForWeekOfYear) { components.insert(.yearForWeekOfYear) }
        if validateMember(nanosecond) { components.insert(.nanosecond) }
        // if validate(calendar) { set.insert(.calendar) }
        // if validate(timeZone) { set.insert(.timeZone) }
        return components
    }
}

/// Standardization
extension DateComponents {
    /// Returns copy with zero-valued components removed
    public var trimmed: DateComponents {
        var copy = DateComponents()
        for component in members {
            // Error workaround where instead of returning nil
            // the values return Int.max
            guard let value = value(for: component),
                value != Int.max, value != Int.min
                else { continue }
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
    public static func +(lhs: DateComponents, rhs: DateComponents) -> DateComponents {
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
    public static func -(lhs: DateComponents, rhs: DateComponents) -> DateComponents {
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
    /// ```
    /// let dc = DateComponents(minute: 7, second: 5)
    /// print(dc.description(remaining: true, approximate: true)) // About 7 minutes, 5 seconds remaining
    /// print(dc.description(style: .approximate)) // About 7 minutes from now
    /// print(dc.description(style: .relative)) // 7 minutes, 5 seconds from now
    /// print(dc.description(style: .standard)) // 7 minutes, 5 seconds
    /// let units: [DateComponentsFormatter.UnitsStyle] = [.positional, .abbreviated, .short, .full, .spellOut]
    /// // 7:05, 7m 5s, 7 min, 5 sec, 7 minutes, 5 seconds, seven minutes, five seconds
    /// for unit in units {
    ///     print(dc.description(units: unit, style: .standard))
    /// }
    /// // print(dc.description(units: .brief, style: .standard)) // 10.12 and later
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
            var string = "About "
            if ti < Date.minute { string += "\(lrint(ti)) seconds" }
            else if abs(ti - Date.minute) <= 3.seconds { string += "a minute" }
            else if ti < Date.hour { string += "\(lrint(ti / Date.minute)) minutes" }
            else if abs(ti - Date.hour) <= (30.minutes) { string += "an hour" }
            else if ti < Date.day { string += "\(lrint(ti / Date.hour)) hours" }
            else if abs(ti - Date.day) <= (12.hours) { string += "a day" }
            else if ti < Date.week { string += "\(lrint(ti / Date.day)) days" }
            else { string += "\(lrint(ti / (Date.week))) weeks" }
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
