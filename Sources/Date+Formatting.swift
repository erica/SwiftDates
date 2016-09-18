import Foundation

// Acknowlegements in Date+Utilities.swift

// Formatters and Strings
public extension Date {
    /// Returns an ISO 8601 formatter
    public static var iso8601Formatter: DateFormatter = {
        $0.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        $0.locale = Locale(identifier: "en_US_POSIX")
        return $0 }(DateFormatter())
    /// Returns a short style date formatter
    public static var shortDateFormatter: DateFormatter = { $0.dateStyle = .short; return $0 }(DateFormatter())
    /// Returns a medium style date formatter
    public static var mediumDateFormatter: DateFormatter = { $0.dateStyle = .medium; return $0 }(DateFormatter())
    /// Returns a long style date formatter
    public static var longDateFormatter: DateFormatter = { $0.dateStyle = .long; return $0 }(DateFormatter())
    /// Returns a full style date formatter
    public static var fullDateFormatter: DateFormatter = { $0.dateStyle = .full; return $0 }(DateFormatter())
    /// Returns a short style time formatter
    public static var shortTimeFormatter: DateFormatter = { $0.timeStyle = .short; return $0 }(DateFormatter())
    /// Returns a medium style time formatter
    public static var mediumTimeFormatter: DateFormatter = { $0.timeStyle = .medium; return $0 }(DateFormatter())
    /// Returns a long style time formatter
    public static var longTimeFormatter: DateFormatter = { $0.timeStyle = .long; return $0 }(DateFormatter())
    /// Returns a full style time formatter
    public static var fullTimeFormatter: DateFormatter = { $0.timeStyle = .full; return $0 }(DateFormatter())
    
    /// Represents date as ISO8601 string
    public var iso8601String: String { return Date.iso8601Formatter.string(from: self) }
    
    /// Returns date components as short string
    public var shortDateString: String { return Date.shortDateFormatter.string(from:self) }
    /// Returns date components as medium string
    public var mediumDateString: String { return Date.mediumDateFormatter.string(from:self) }
    /// Returns date components as long string
    public var longDateString: String { return Date.longDateFormatter.string(from:self) }
    /// Returns date components as full string
    public var fullDateString: String { return Date.fullDateFormatter.string(from:self) }
    
    /// Returns time components as short string
    public var shortTimeString: String { return Date.shortTimeFormatter.string(from:self) }
    /// Returns time components as medium string
    public var mediumTimeString: String { return Date.mediumTimeFormatter.string(from:self) }
    /// Returns time components as long string
    public var longTimeString: String { return Date.longTimeFormatter.string(from:self) }
    /// Returns time components as full string
    public var fullTimeString: String { return Date.fullTimeFormatter.string(from:self) }
    
    /// Returns date and time components as short string
    public var shortString: String { return "\(self.shortDateString) \(self.shortTimeString)" }
    /// Returns date and time components as medium string
    public var mediumString: String { return "\(self.mediumDateString) \(self.mediumTimeString)" }
    /// Returns date and time components as long string
    public var longString: String { return "\(self.longDateString) \(self.longTimeString)" }
    /// Returns date and time components as full string
    public var fullString: String { return "\(self.fullDateString) \(self.fullTimeString)" }
}
