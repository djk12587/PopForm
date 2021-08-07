//
//  File.swift
//  
//
//  Created by Dan Koza on 7/26/21.
//

import Foundation

public protocol FormFieldDelegate: AnyObject {
    func formFieldValidationStateChanged()
}

public protocol FormField: AnyObject {
    /// Delegate that broadcasts when the `FormFieldValidationState` changes
    var formFieldValidationDelegate: FormFieldDelegate? { get set }
    /// The current validation state of a `ValidatableFormField` states are `.valid`, `.invalid`, `.unknown`.
    var validationState: FormFieldValidationState { get set }
    /// Put logic here to decide when the `ValidatableFormField` is either `.valid`, `.invalid`, `.unknown`.
    var validationPredicate: (() -> FormFieldValidationState)? { get set }
    /// Callback intended to indicate when the `FormFieldValidationState` changes
    var validationStateDidChangeHandler: ((FormFieldValidationState) -> Void)? { get set }
}

extension FormField {
    /// `Bool` indicating if the `ValidatableFormField` is current set to a `FormFieldValidationState` of `.valid`
    var isValid: Bool { validationState == .valid }
}

public enum FormFieldValidationState {
    case unknown
    case `default`
    case invalid
    case valid
}
