import Foundation

// Acknowlegements in Date+Utilities.swift

/// Components
public extension Date {
    /// Returns set of common date components
    public static var commonComponents: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
    
    /// Returns set of exhaustive date components
    public static var allComponents: Set<Calendar.Component> = [.era, .year, .month, .day, .hour, .minute, .second, .weekday, .weekdayOrdinal, .quarter, .weekOfMonth, .weekOfYear, .yearForWeekOfYear, .nanosecond, .calendar, .timeZone]
    
    /// Returns set of MDY date components
    public static var dateComponents: Set<Calendar.Component> = [.year, .month, .day]
    
    /// Returns set of HMS
    public static var timeComponents: Set<Calendar.Component> = [.hour, .minute, .second, ]
    
    /// Returns set of MDYHMS components
    public static var dateAndTimeComponents: Set<Calendar.Component> = [.hour, .minute, .second, .year, .month, .day]
}

/// Components from Dates
public extension Date {
    
    /// Extracts of MDY components
    var dateComponents: DateComponents {
        return Date.sharedCalendar.dateComponents([.month, .day, .year], from: self)
    }
    
    /// Extracts HMS components
    var timeComponents: DateComponents {
        return Date.sharedCalendar.dateComponents([.hour, .minute, .second], from: self)
    }
    
    /// Extracts MDYHMS components
    var dateAndTimeComponents: DateComponents {
        return Date.sharedCalendar.dateComponents([.month, .day, .year, .hour, .minute, .second], from: self)
    }
    
    /// Extracts common date components for date
    public var components: DateComponents { return Date.sharedCalendar.dateComponents(Date.commonComponents, from: self) }
    
    /// Extracts all date components for date
    public var allComponents: DateComponents { return Date.sharedCalendar.dateComponents(Date.allComponents, from: self) }
}


/// Alternative offset approach that constructs date components for offset duty
/// I find this more verbose, less readable, less functional but your mileage may vary
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

/// Date and Component Utility
extension Date {
    /// Offset a date by n calendar components. Can be functionally chained
    /// For example:
    ///
    /// ```
    /// let afterThreeDays = date.offset(.day, 3)
    /// print(Date().offset(.day, 3).offset(.hour, 1).fullString)
    /// ```
    ///
    /// Not all components or offsets are useful
    public func offset(_ component: Calendar.Component, _ count: Int) -> Date {
        var newComponent: DateComponents = DateComponents(second: 0)
        switch component {
        case .era: newComponent = DateComponents(era: count)
        case .year: newComponent = DateComponents(year: count)
        case .month: newComponent = DateComponents(month: count)
        case .day: newComponent = DateComponents(day: count)
        case .hour: newComponent = DateComponents(hour: count)
        case .minute: newComponent = DateComponents(minute: count)
        case .second: newComponent = DateComponents(second: count)
        case .weekday: newComponent = DateComponents(weekday: count)
        case .weekdayOrdinal: newComponent = DateComponents(weekdayOrdinal: count)
        case .quarter: newComponent = DateComponents(quarter: count)
        case .weekOfMonth: newComponent = DateComponents(weekOfMonth: count)
        case .weekOfYear: newComponent = DateComponents(weekOfYear: count)
        case .yearForWeekOfYear: newComponent = DateComponents(yearForWeekOfYear: count)
        case .nanosecond: newComponent = DateComponents(nanosecond: count)
            // These items complete the component vocabulary but cannot be used in this way
            // case .calendar: newComponent = DateComponents(calendar: count)
        // case .timeZone: newComponent = DateComponents(timeZone: count)
        default: break
        }
        
        // If offset is not possible, return unmodified date
        return Date.sharedCalendar.date(byAdding: newComponent, to: self) ?? self
    }
}

/// Subscripting
extension DateComponents {
    /// Introduces date component subscripting
    /// This does not take into account any built-in errors
    /// Where Int.max returned instead of nil
    public subscript(component: Calendar.Component) -> Int? {
        switch component {
        case .era: return era
        case .year: return year
        case .month: return month
        case .day: return day
        case .hour: return hour
        case .minute: return minute
        case .second: return second
        case .weekday: return weekday
        case .weekdayOrdinal: return weekdayOrdinal
        case .quarter: return quarter
        case .weekOfMonth: return weekOfMonth
        case .weekOfYear: return weekOfYear
        case .yearForWeekOfYear: return yearForWeekOfYear
        case .nanosecond: return nanosecond
            // case .calendar: return self.calendar
        // case .timeZone: return self.timeZone
        default: return nil
        }
    }
}

// For Frederic B
// e.g.
//    let dc = DateComponents(ti: 1.weekInteval + 1.dayInterval
//          + 3.hourInterval + 5.minuteInterval + 4.secondInterval)
extension DateComponents {
    public init(ti: TimeInterval) {
        let referenceDate = Date(timeIntervalSinceReferenceDate: 0)
        let offsetDate = Date(timeIntervalSinceReferenceDate: ti)
        self = Date.sharedCalendar
            .dateComponents(Date.commonComponents,
                            from: referenceDate,
                            to: offsetDate)
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
        
        let formatter: DateComponentsFormatter = {
            $0.calendar = Date.sharedCalendar
            $0.unitsStyle = units
            $0.includesTimeRemainingPhrase = remaining
            $0.includesApproximationPhrase = approximate
            return $0
        }(DateComponentsFormatter())
        
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
            if ti < Date.minuteInterval { string += "\(lrint(ti)) seconds" }
            else if abs(ti - Date.minuteInterval) <= 3.secondInterval { string += "a minute" }
            else if ti < Date.hourInterval { string += "\(lrint(ti / Date.minuteInterval)) minutes" }
            else if abs(ti - Date.hourInterval) <= (30.minuteInterval) { string += "an hour" }
            else if ti < Date.dayInterval { string += "\(lrint(ti / Date.hourInterval)) hours" }
            else if abs(ti - Date.dayInterval) <= (12.hourInterval) { string += "a day" }
            else if ti < Date.weekInterval { string += "\(lrint(ti / Date.dayInterval)) days" }
            else { string += "\(lrint(ti / (Date.weekInterval))) weeks" }
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

