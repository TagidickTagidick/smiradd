import SwiftUI

class CustomFormatter {
    static func formatPhoneNumber(_ phoneNumber: String) -> String {
        let digits = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        var formattedPhoneNumber = ""
        if digits.count == 11 {
            formattedPhoneNumber = digits.prefix(1) + " " + "("
            formattedPhoneNumber += digits.dropFirst(1).prefix(3) + ") "
            formattedPhoneNumber += digits.dropFirst(4).prefix(3) + "-"
            formattedPhoneNumber += digits.dropFirst(7).prefix(2) + "-"
            formattedPhoneNumber += digits.dropFirst(9)
        }
        return formattedPhoneNumber
    }
    
    static func formattedTime(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
    
    static func convertDateString(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        
        if let date = dateFormatter.date(from: dateString) {
            let calendar = Calendar.current
            if calendar.isDateInToday(date) {
                return "Сегодня в \(formattedTime(from: date))"
            } else if calendar.isDateInYesterday(date) {
                return "Вчера в \(formattedTime(from: date))"
            } else if calendar.isDateInTomorrow(date) {
                return "Завтра в \(formattedTime(from: date))"
            } else {
                let daysAgo = calendar.dateComponents([.day], from: date, to: Date()).day ?? 0
                if daysAgo == -2 {
                    return "Позавчера в \(formattedTime(from: date))"
                } else {
                    dateFormatter.dateFormat = "dd.MM.yyyy в HH:mm"
                    return dateFormatter.string(from: date)
                }
            }
        } else {
            return "Invalid date format"
        }
    }
}
