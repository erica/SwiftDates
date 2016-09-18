import Foundation

// Thanks: AshFurrow, sstreza, Scott Lawrence, Kevin Ballard, NoOneButMe, Avi`, August Joki, Lily Vulcano, jcromartiej, Blagovest Dachev, Matthias Plappert,  Slava Bushtruk, Ali Servet Donmez, Ricardo1980, pip8786, Danny Thuerin, Dennis Madsen, Greg Titus, Jim Morrison, aclark, Marcin Krzyzanowski, dmitrydims, Sebastian Celis, Seyithan Teymur,

/// Shared static properties
public extension Date {
    /// Returns common shared calendar, user's preferred calendar
    /// This calendar tracks changes to user’s preferred calendar identifier
    /// unlike `current`.
    public static var sharedCalendar = Calendar.autoupdatingCurrent
    /// Returns the current time
    public static var now: Date { return Date() }
}


/// Inherent date properties / component retrieval
/// Some of these are entirely pointless but I have included all components
public extension Date {
    
    /// Returns date's time interval since reference date
    public var interval: TimeInterval { return self.timeIntervalSinceReferenceDate }
    
    
    // MARK: YMD
    
    /// Returns instance's year component
    public var year: Int { return Date.sharedCalendar.component(.year, from: self) }
    /// Returns instance's month component
    public var month: Int { return Date.sharedCalendar.component(.month, from: self) }
    /// Returns instance's day component
    public var day: Int { return Date.sharedCalendar.component(.day, from: self) }
    /// Returns instance's hour component
    
    
    // MARK: HMS
    
    public var hour: Int { return Date.sharedCalendar.component(.hour, from: self) }
    /// Returns instance's minute component
    public var minute: Int { return Date.sharedCalendar.component(.minute, from: self) }
    /// Returns instance's second component
    public var second: Int { return Date.sharedCalendar.component(.second, from: self) }
    /// Returns instance's nanosecond component
    public var nanosecond: Int { return Date.sharedCalendar.component(.nanosecond, from: self) }  
    
    // MARK: Weeks
    
    /// Returns instance's weekday component
    public var weekday: Int { return Date.sharedCalendar.component(.weekday, from: self) }
    /// Returns instance's weekdayOrdinal component
    public var weekdayOrdinal: Int { return Date.sharedCalendar.component(.weekdayOrdinal, from: self) }
    /// Returns instance's weekOfMonth component
    public var weekOfMonth: Int { return Date.sharedCalendar.component(.weekOfMonth, from: self) }
    /// Returns instance's weekOfYear component
    public var weekOfYear: Int { return Date.sharedCalendar.component(.weekOfYear, from: self) }
    /// Returns instance's yearForWeekOfYear component
    public var yearForWeekOfYear: Int { return Date.sharedCalendar.component(.yearForWeekOfYear, from: self) }
    
    // MARK: Other
    
    /// Returns instance's quarter component
    public var quarter: Int { return Date.sharedCalendar.component(.quarter, from: self) }
    /// Returns instance's (meaningless) era component
    public var era: Int { return Date.sharedCalendar.component(.era, from: self) }
    /// Returns instance's (meaningless) calendar component
    public var calendar: Int { return Date.sharedCalendar.component(.calendar, from: self) }
    /// Returns instance's (meaningless) timeZone component.
    public var timeZone: Int { return Date.sharedCalendar.component(.timeZone, from: self) }
}

// Date characteristics
extension Date {
    /// Returns true if date falls before current date
    public var isPast: Bool { return self < Date() }
    
    /// Returns true if date falls after current date
    public var isFuture: Bool { return self > Date() }
    
    /// Returns true if date falls on typical weekend
    public var isTypicallyWeekend: Bool {
        return Date.sharedCalendar.isDateInWeekend(self)
    }
    /// Returns true if date falls on typical workday
    public var isTypicallyWorkday: Bool { return !self.isTypicallyWeekend }
}

// Date distances
public extension Date {
    /// Returns the time interval between two dates
    public static func interval(_ date1: Date, _ date2: Date) -> TimeInterval {
        return date2.interval - date1.interval
    }
    
    /// Returns a time interval between the instance and another date
    public func interval(to date: Date) -> TimeInterval {
        return Date.interval(self, date)
    }
    
    /// Returns the distance between two dates
    /// using the user's preferred calendar
    /// e.g.
    /// ```
    /// let date1 = Date.shortDateFormatter.date(from: "1/1/16")!
    /// let date2 = Date.shortDateFormatter.date(from: "3/13/16")!
    /// Date.distance(date1, to: date2, component: .day) // 72
    /// ```
    /// - Warning: Returns 0 for bad components rather than crashing
    public static func distance(_ date1: Date, to date2: Date, component: Calendar.Component) -> Int {
        return Date.sharedCalendar.dateComponents([component], from: date1, to: date2)[component] ?? 0
    }
    
    /// Returns the distance between the instance and another date
    /// using the user's preferred calendar
    /// e.g.
    /// ```
    /// let date1 = Date.shortDateFormatter.date(from: "1/1/16")!
    /// let date2 = Date.shortDateFormatter.date(from: "3/13/16")!
    /// date1.distance(to: date2, component: .day) // 72
    /// ```
    /// - Warning: Returns 0 for bad components rather than crashing
    public func distance(to date: Date, component: Calendar.Component) -> Int {
        return Date.sharedCalendar.dateComponents([component], from: self, to: date)[component] ?? 0
    }
    
    /// Returns the number of days between the instance and a given date. May be negative
    public func days(to date: Date) -> Int { return distance(to: date, component: .day) }
    /// Returns the number of hours between the instance and a given date. May be negative
    public func hours(to date: Date) -> Int { return distance(to: date, component: .hour) }
    /// Returns the number of minutes between the instance and a given date. May be negative
    public func minutes(to date: Date) -> Int { return distance(to: date, component: .minute) }
    /// Returns the number of seconds between the instance and a given date. May be negative
    public func seconds(to date: Date) -> Int { return distance(to: date, component: .second) }
    
    /// Returns a (days, hours, minutes, seconds) tuple representing the
    /// time remaining between the instance and a target date.
    /// Not for exact use. For example:
    ///
    /// ```
    /// let test = Date().addingTimeInterval(5.days + 3.hours + 2.minutes + 10.seconds)
    /// print(Date().offsets(to: test))
    /// // prints (5, 3, 2, 10 or possibly 9 but rounded up)
    /// ```
    ///
    /// - Warning: returns 0 for any error when fetching component
    public func offsets(to date: Date) -> (days: Int, hours: Int, minutes: Int, seconds: Int) {
        let components = Date.sharedCalendar
            .dateComponents([.day, .hour, .minute, .second],
                            from: self, to: date.addingTimeInterval(0.5)) // round up
        return (
            days: components[.day] ?? 0,
            hours: components[.hour] ?? 0,
            minutes: components[.minute] ?? 0,
            seconds: components[.second] ?? 0
        )
    }
}

// Utility
public extension Date {
    /// Return the nearest hour using a 24 hour clock
    public var nearestHour: Int { return (self.offset(.minute, 30)).hour }
    
    /// Return the nearest minute
    public var nearestMinute: Int { return (self.offset(.second, 30)).minute }
}

// Canonical dates
extension Date {
    
    /// Returns a date representing midnight at the start of this day
    public var startOfDay: Date {
        let midnight = DateComponents(year: components.year, month: components.month, day: components.day)
        // If offset is not possible, return unmodified date
        return Date.sharedCalendar.date(from: midnight) ?? self
    }
    /// Returns a date representing midnight at the start of this day.
    /// Is synonym for `startOfDay`.
    public var today: Date { return self.startOfDay }
    /// Returns a date representing midnight at the start of tomorrow
    public var tomorrow: Date { return self.today.offset(.day, 1) }
    /// Returns a date representing midnight at the start of yesterday
    public var yesterday: Date { return self.today.offset(.day, -1) }
    
    /// Returns today's date at the midnight starting the day
    public static var today: Date { return Date().startOfDay }
    /// Returns tomorrow's date at the midnight starting the day
    public static var tomorrow: Date { return Date.today.offset(.day, 1) }
    /// Returns yesterday's date at the midnight starting the day
    public static var yesterday: Date { return Date.today.offset(.day, -1) }
    
    /// Returns a date representing a second before midnight at the end of the day
    public var endOfDay: Date { return self.tomorrow.startOfDay.offset(.second, -1) }
    /// Returns a date representing a second before midnight at the end of today
    public static var endOfToday: Date { return Date().endOfDay }
    
    /// Determines whether two days share the same date
    public static func sameDate(_ date1: Date, _ date2: Date) -> Bool {
        return Date.sharedCalendar.isDate(date1, inSameDayAs: date2)
    }
    
    /// Returns true if this date is the same date as today for the user's preferred calendar
    public var isToday: Bool { return Date.sharedCalendar.isDateInToday(self) }
    /// Returns true if this date is the same date as tomorrow for the user's preferred calendar
    public var isTomorrow: Bool { return Date.sharedCalendar.isDateInTomorrow(self) }
    /// Returns true if this date is the same date as yesterday for the user's preferred calendar
    public var isYesterday: Bool { return Date.sharedCalendar.isDateInYesterday(self) }
    
    /// Returns the start of the instance's week of year for user's preferred calendar
    public var startOfWeek: Date {
        let components = self.allComponents
        let startOfWeekComponents = DateComponents(weekOfYear: components.weekOfYear, yearForWeekOfYear: components.yearForWeekOfYear)
        // If offset is not possible, return unmodified date
        return Date.sharedCalendar.date(from: startOfWeekComponents) ?? self
    }
    /// Returns the start of the current week of year for user's preferred calendar
    public static var thisWeek: Date {
        return Date().startOfWeek
    }
    
    /// Returns the start of next week of year for user's preferred calendar
    public var nextWeek: Date { return self.offset(.weekOfYear, 1) }
    /// Returns the start of last week of year for user's preferred calendar
    public var lastWeek: Date { return self.offset(.weekOfYear, -1) }
    /// Returns the start of next week of year for user's preferred calendar relative to date
    public static var nextWeek: Date { return Date().offset(.weekOfYear, 1) }
    /// Returns the start of last week of year for user's preferred calendar relative to date
    public static var lastWeek: Date { return Date().offset(.weekOfYear, -1) }
    
    /// Returns true if two weeks likely fall within the same week of year
    /// in the same year, or very nearly the same year
    public static func sameWeek(_ date1: Date, _ date2: Date) -> Bool {
        return date1.startOfWeek == date2.startOfWeek
    }
    
    /// Returns true if date likely falls within the current week of year
    public var isThisWeek: Bool { return Date.sameWeek(self, Date.thisWeek) }
    /// Returns true if date likely falls within the next week of year
    public var isNextWeek: Bool { return Date.sameWeek(self, Date.nextWeek) }
    /// Returns true if date likely falls within the previous week of year
    public var isLastWeek: Bool { return Date.sameWeek(self, Date.lastWeek) }
    
    /// Returns the start of year for the user's preferred calendar
    public static var thisYear: Date {
        let components = Date().components
        let theyear = DateComponents(year: components.year)
        // If offset is not possible, return unmodified date
        return Date.sharedCalendar.date(from: theyear) ?? Date()
    }
    /// Returns the start of next year for the user's preferred calendar
    public static var nextYear: Date { return thisYear.offset(.year, 1) }
    /// Returns the start of previous year for the user's preferred calendar
    public static var lastYear: Date { return thisYear.offset(.year, -1) }
    
    /// Returns true if two dates share the same year component
    public static func sameYear(_ date1: Date, _ date2: Date) -> Bool {
        return date1.allComponents.year == date2.allComponents.year
    }
    
    /// Returns true if date falls within this year for the user's preferred calendar
    public var isThisYear: Bool { return Date.sameYear(self, Date.thisYear) }
    /// Returns true if date falls within next year for the user's preferred calendar
    public var isNextYear: Bool { return Date.sameYear(self, Date.nextYear) }
    /// Returns true if date falls within previous year for the user's preferred calendar
    public var isLastYear: Bool { return Date.sameYear(self, Date.lastYear) }
}
