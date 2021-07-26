//
//  File.swift
//  
//
//  Created by Dan Koza on 7/26/21.
//

import Foundation

public protocol FormFieldValidator {
    func validate(text: String) -> FormFieldValidationState
}
