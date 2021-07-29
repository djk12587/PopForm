//
//  File.swift
//  
//
//  Created by Dan Koza on 7/26/21.
//

import Foundation

public protocol FormFieldValidationDelegate: AnyObject {
    func formFieldValidationStateChanged()
}

public protocol ValidatableFormField: AnyObject {

    var formFieldValidationDelegate: FormFieldValidationDelegate? { get set }
    var validationState: FormFieldValidationState { get set }
    var validationPredicate: (() -> FormFieldValidationState)? { get set }
    var validationStateDidChangeHandler: (() -> Void)? { get set }

    /// Initialize a ValidatableFormField with a`validationPredicate` or `validationStateDidChangeHandler`
    /// - Parameters:
    ///   - validationPredicate: Put logic here to decide when the `ValidatableFormField` is either `.valid`, `.invalid`, `.unknown`. The `validationPredicate`
    ///   - validationStateDidChangeHandler: Callback intended to indicate when the `validationPredicate` returns a different `FormFieldValidationState`
    init(validationPredicate: (() -> FormFieldValidationState)?, validationStateDidChangeHandler: (() -> Void)?)
}

public enum FormFieldValidationState {
    case unknown
    case invalid
    case valid
}
