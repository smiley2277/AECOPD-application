import Foundation

class DateFormat: NSObject {
    static var shared = DateFormat()
    
    func dateFormat(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "GMT+8")
        let dateString = dateFormatter.string(from: date as Date)
        return dateString
    }

    func dateFormatLong(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        dateFormatter.timeZone = TimeZone(identifier: "GMT+8")
        let dateString = dateFormatter.string(from: date as Date)
        return dateString
    }
    
    func dateFormatWith(format: String, date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(identifier: "GMT+8")
        let dateString = dateFormatter.string(from: date as Date)
        return dateString
    }
    
    func dateFormatWith(format: String, string: String?) -> Date? {
        if string == nil { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
       // dateFormatter.timeZone = TimeZone(identifier: "GMT+00:00")
        let date = dateFormatter.date(from: string!)
        return date
    }
}
