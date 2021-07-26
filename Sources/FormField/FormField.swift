//
//  File.swift
//  
//
//  Created by Dan Koza on 7/26/21.
//

import Foundation

public protocol FormField {
    var validator: FormFieldValidator { get }
    var formatter: FormFieldFormatter { get }
    var validationState: FormFieldValidationState { get set }
    var isValid: Bool { get }
}

public extension FormField {
    var isValid: Bool { validationState == .valid }
}
