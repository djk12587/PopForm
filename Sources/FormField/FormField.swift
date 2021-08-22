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

    /// Call this function when your FormField needs validation. Returns a Boolean indicating if the `validationState` changed.
    @discardableResult
    func validationNeeded() -> Bool

    /// Delegate that broadcasts when the `FormFieldValidationState` changes
    var formFieldValidationDelegate: FormFieldDelegate? { get set }
    /// The current validation state of a `ValidatableFormField` states are `.valid`, `.invalid`, `.unknown`, `.default`.
    var validationState: FormFieldValidationState { get set }
    /// Put logic here to decide when the `ValidatableFormField` is either `.valid`, `.invalid`, `.unknown`, `.default`.
    var validationPredicate: (() -> FormFieldValidationState)? { get set }
    /// Callback intended to indicate when the `FormFieldValidationState` changes
    var validationStateDidChangeHandler: ((FormFieldValidationState) -> Void)? { get set }
    /// The `preValidationPredicate` is executed before the `validationPreditcate` is ran. If false is returned, then the `validationPredicate` will not be executed. Another common use for this this can be to allow custom formatting.
    var preValidationPredicate: (() -> Bool)? { get set }
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

public extension FormField {

    /// Clears existing validationPredicates and sets up a brand new `validationPredicate`. The predicate is executed before `setValidation(predicate:)` finishes.
    /// - Parameters:
    ///   - predicate: Logic  to determine when the `ValidatableFormField`'s `FormFieldValidationState`. This predicate is executed when `validationNeeded` is executed.
    func setValidation(predicate: @escaping () -> FormFieldValidationState) {
        validationPredicate = predicate
        validationNeeded()
    }

    /// Sets the `validationStateDidChangeHandler`. The handler is executed before `setValidationStateDidChange(handler:)` finishes
    /// - Parameter handler: Callback handler that used to trigger events when the `ValidatableFormField`'s `FormFieldValidationState` changes
    func setValidationStateDidChange(handler: @escaping ((FormFieldValidationState) -> Void)) {
        validationStateDidChangeHandler = handler
        handler(validationState)
    }

    /// Sets the `preValidationPredicate`. The predicate is executed before the `validationPredicate` is ran. If false is returned, then the `validationPredicate` is not ran.
    /// - Parameter handler: Callback handler that used to trigger events when the `ValidatableFormField`'s `FormFieldValidationState` changes
    func setPreValidation(predicate: @escaping (() -> Bool)) {
        preValidationPredicate = predicate
    }

    /// Runs the validation
    /// - Returns: A `Bool` indicating if the validationState did change
    func validationNeeded() -> Bool {
        return validate()
    }

    /// Runs the validation
    /// - Returns: A `Bool` indicating if the validationState did change
    private func validate() -> Bool {

        guard preValidationPredicate?() ?? true else { return false }

        let previousValidationState = validationState
        validationState = validationPredicate?() ?? .unknown

        let validationStateDidChange = previousValidationState != validationState
        if validationStateDidChange {
            validationStateDidChangeHandler?(validationState)
            formFieldValidationDelegate?.formFieldValidationStateChanged()
        }

        return validationStateDidChange
    }
}
