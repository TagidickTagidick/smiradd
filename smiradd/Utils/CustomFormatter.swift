import SwiftUI

class Formatter {
    func formatPhoneNumber(_ phoneNumber: String) -> String {
        var formattedNumber = phoneNumber

        // Удаляем все символы, кроме цифр
        formattedNumber = formattedNumber.replacingOccurrences(of: "\\D", with: "", options: .regularExpression)

        // Добавляем код страны
        formattedNumber.insert("7", at: formattedNumber.startIndex)

        // Форматируем номер телефона
        if let range = Range(NSMakeRange(1, 3), in: formattedNumber) {
            formattedNumber.insert("(", at: range.lowerBound)
            formattedNumber.insert(")", at: formattedNumber.index(after: range.lowerBound))
        }
        if let range = Range(NSMakeRange(2, 3), in: formattedNumber) {
            formattedNumber.insert(" ", at: range.lowerBound)
        }
        if let range = Range(NSMakeRange(6, 2), in: formattedNumber) {
            formattedNumber.insert("-", at: range.lowerBound)
        }
        if let range = Range(NSMakeRange(9, 2), in: formattedNumber) {
            formattedNumber.insert("-", at: range.lowerBound)
        }

        return formattedNumber
    }
}
