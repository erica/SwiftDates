import Foundation

// Acknowlegements in Date+Utilities.swift

// Calendar functionality for date component retrieval
// Some of these are entirely pointless but I have included all components
public extension Calendar {
    /// Returns instance's year component
    public func year(of date: Date) -> Int { return component(.year, from: date) }
    /// Returns instance's month component
    public func month(of date: Date) -> Int { return component(.month, from: date) }
    /// Returns instance's day component
    public func day(of date: Date) -> Int { return component(.day, from: date) }
    /// Returns instance's hour component
    public func hour(of date: Date) -> Int { return component(.hour, from: date) }
    /// Returns instance's minute component
    public func minute(of date: Date) -> Int { return component(.minute, from: date) }
    /// Returns instance's second component
    public func second(of date: Date) -> Int { return component(.second, from: date) }
    
    /// Returns instance's weekday component
    public func weekday(of date: Date) -> Int { return component(.weekday, from: date) }
    /// Returns instance's weekdayOrdinal component
    public func weekdayOrdinal(of date: Date) -> Int { return component(.weekdayOrdinal, from: date) }
    /// Returns instance's weekOfMonth component
    public func weekOfMonth(of date: Date) -> Int { return component(.weekOfMonth, from: date) }
    /// Returns instance's weekOfYear component
    public func weekOfYear(of date: Date) -> Int { return component(.weekOfYear, from: date) }
    
    /// Returns instance's yearForWeekOfYear component
    public func yearForWeekOfYear(of date: Date) -> Int { return component(.yearForWeekOfYear, from: date) }
    
    /// Returns instance's quarter component
    public func quarter(of date: Date) -> Int { return component(.quarter, from: date) }
    
    /// Returns instance's nanosecond component
    public func nanosecond(of date: Date) -> Int { return component(.nanosecond, from: date) }
    /// Returns instance's (meaningless) era component
    public func era(of date: Date) -> Int { return component(.era, from: date) }
    /// Returns instance's (meaningless) calendar component
    public func calendar(of date: Date) -> Int { return component(.calendar, from: date) }
    /// Returns instance's (meaningless) timeZone component.
    public func timeZone(of date: Date) -> Int { return component(.timeZone, from: date) }
    
    /// Extracts common date components for date
    public func commonComponents(of date: Date) -> DateComponents { return dateComponents(Date.commonComponents, from: date) }
    /// Extracts all date components for date
    public func allComponents(of date: Date) -> DateComponents { return dateComponents(Date.allComponents, from: date) }
}

