//
//  File.swift
//  
//
//  Created by Dan Koza on 7/26/21.
//

import UIKit

enum DefaultFormFieldFormatter: FormFieldFormatter {
    case none
    case zipCode
    case phoneNumber
    case custom((UITextField) -> Void)

    func format(textField: UITextField) -> Void {
        switch self {
            case .none:
                break

            case .zipCode:
                let cursorPosition = textField.selectedTextRange
                let text = textField.text ?? ""
                textField.text = String(
                    text.components(separatedBy: CharacterSet.decimalDigits.inverted)
                        .joined()
                        .prefix(5)
                )
                textField.selectedTextRange = cursorPosition

            case .phoneNumber:
                textField.text = formatPhone(textField.text ?? "")

            case .custom(let customValidator):
                customValidator(textField)
        }
    }
}

private func formatPhone(_ number: String) -> String {
    let cleanNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    let format: [Character] = ["X", "X", "X", "-", "X", "X", "X", "-", "X", "X", "X", "X"]

    var result = ""
    var index = cleanNumber.startIndex
    for ch in format {
        if index == cleanNumber.endIndex {
            break
        }
        if ch == "X" {
            result.append(cleanNumber[index])
            index = cleanNumber.index(after: index)
        } else {
            result.append(ch)
        }
    }
    return result
}
