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
    var validator: (() -> FormFieldValidationState)? { get set }

    init(validator: (() -> FormFieldValidationState)?)
    func setValidation(validator: @escaping () -> FormFieldValidationState)
    func validationStateDidChange()
}

public extension ValidatableFormField {

    func setValidation(validator: @escaping () -> FormFieldValidationState) {
        self.validator = validator
    }

    func set(validationListener: FormFieldValidationListener) {
        self.validationListener = validationListener
    }

    func validationStateDidChange() {}
}

public extension ValidatableFormField where Self: UIControl {

    init(validator: (() -> FormFieldValidationState)?) {
        self.init(frame: .zero)
        self.validator = validator
        setupEditingAction()
    }

    func setValidation(validator: @escaping () -> FormFieldValidationState) {
        self.validator = validator
        setupEditingAction()
    }

    func set(validationListener: FormFieldValidationListener) {
        self.validationListener = validationListener
    }

    private func setupEditingAction() {
        addAction(for: .allEditingEvents) { [weak self] in
            guard let self = self else { return }

            let previousFormState = self.validationState
            self.validationState = self.validator?() ?? .unknown
            if previousFormState != self.validationState {
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
