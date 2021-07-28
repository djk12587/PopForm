//
//  File.swift
//  
//
//  Created by Dan Koza on 7/26/21.
//

import UIKit

public protocol FormFieldValidationListener: AnyObject {
    func validatableFormFieldWasEdited()
}

public protocol ValidatableFormField: AnyObject {

    var validationListener: FormFieldValidationListener? { get set }
    var validationState: FormFieldValidationState { get set }
    var validationHandler: (() -> FormFieldValidationState)? { get set }
    var validationStateDidChangeHandler: (() -> Void)? { get set }

    init(validator: (() -> FormFieldValidationState)?, validationStateDidChangeHandler: (() -> Void)?)
    func setValidation(handler: @escaping () -> FormFieldValidationState)
    func setValidationStateDidChangeHandler(handler: @escaping () -> Void)
}

public extension ValidatableFormField {

    func setValidation(handler: @escaping () -> FormFieldValidationState) {
        validationHandler = handler
    }

    func setValidationStateDidChangeHandler(handler: @escaping () -> Void) {
        validationStateDidChangeHandler = handler
    }

    func set(validationListener: FormFieldValidationListener) {
        self.validationListener = validationListener
    }
}

public extension ValidatableFormField where Self: UIControl {

    init(validator: (() -> FormFieldValidationState)?, validationStateDidChangeHandler: (() -> Void)?) {
        self.init(frame: .zero)
        self.validationHandler = validator
        self.validationStateDidChangeHandler = validationStateDidChangeHandler
        setupEditingAction()
    }

    func setValidation(handler: @escaping () -> FormFieldValidationState) {
        validationHandler = handler
        setupEditingAction()
    }

    func set(validationListener: FormFieldValidationListener) {
        self.validationListener = validationListener
    }

    private func setupEditingAction() {
        addAction(for: .allEditingEvents) { [weak self] in
            guard let self = self else { return }

            let previousFormState = self.validationState
            self.validationState = self.validationHandler?() ?? .unknown
            if previousFormState != self.validationState {
                self.validationStateDidChangeHandler?()
                self.validationListener?.validatableFormFieldWasEdited()
            }
        }
    }
}

public enum FormFieldValidationState {
    case unknown
    case invalid
    case valid
}

class ClosureWrapper {
    let closure: () -> Void

    init(closure: @escaping () -> Void) {
        self.closure = closure
    }

    @objc func invoke() {
        closure()
    }
}

extension UIControl {
    func addAction(for controlEvents: UIControl.Event, action: @escaping () -> Void) {
        let wrapper = ClosureWrapper(closure: action)
        addTarget(wrapper, action: #selector(ClosureWrapper.invoke), for: controlEvents)
        objc_setAssociatedObject(self,
                                 "[\(arc4random())]",
                                 wrapper,
                                 .OBJC_ASSOCIATION_RETAIN)
    }
}
