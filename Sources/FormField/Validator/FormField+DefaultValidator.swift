//
//  File.swift
//  
//
//  Created by Dan Koza on 7/26/21.
//

import UIKit
import Foundation

//public enum DefaultFormFieldValidator: FormFieldValidator {
//    public func validate(field: DefaultFormFieldValidator) -> FormFieldValidationState {
//        
//    }
//
//    public func validate(field: UIControl) -> FormFieldValidationState {
//        return .empty
//    }
//
////    public func validate(field: UIControl) -> FormFieldValidationState {
////        <#code#>
////    }
//
//    case zipCode
//    case custom((String) -> FormFieldValidationState)
//
//    public func validate(text: String) -> FormFieldValidationState {
//        switch self {
//            case .zipCode:
//                let isValidZipcode = CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: text)) && text.count == 5
//                return isValidZipcode ? .valid : .invalid
//
//            case .custom(let customValidator):
//                return customValidator(text)
//        }
//    }
//}
