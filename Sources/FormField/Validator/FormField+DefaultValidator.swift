//
//  File.swift
//  
//
//  Created by Dan Koza on 7/26/21.
//

import Foundation

public enum DefaultFormFieldValidator: FormFieldValidator {
    case zipCode
    case custom((String) -> FormFieldValidationState)

    public func validate(text: String) -> FormFieldValidationState {
        switch self {
            case .zipCode:
                let isValidZipcode = CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: text)) && text.count == 5
                return isValidZipcode ? .valid : .invalid

            case .custom(let customValidator):
                return customValidator(text)
        }
    }
}
