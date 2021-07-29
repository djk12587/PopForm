//
//  File.swift
//  
//
//  Created by Dan Koza on 7/26/21.
//

import UIKit

public extension ValidatableFormField where Self: UIControl {

    //   - executeValidation: After initializtion, this `BOOL` will envoke the `validationPredicate` or `validationStateDidChangeHandler` once.
    init(validationPredicate: (() -> FormFieldValidationState)?, validationStateDidChangeHandler: (() -> Void)?) {
        self.init(frame: .zero)
        self.validationPredicate = validationPredicate
        self.validationStateDidChangeHandler = validationStateDidChangeHandler
        setupControlEventListeners(send: nil)
    }

    init(validationPredicate: (() -> FormFieldValidationState)?, validationStateDidChangeHandler: (() -> Void)?, send controlEvent: UIControl.Event? = nil) {
        self.init(frame: .zero)
        self.validationPredicate = validationPredicate
        self.validationStateDidChangeHandler = validationStateDidChangeHandler
        setupControlEventListeners(send: controlEvent)
    }

    func setValidation(predicate: @escaping () -> FormFieldValidationState, send controlEvent: UIControl.Event? = nil) {
        validationPredicate = predicate
        setupControlEventListeners(send: controlEvent)
    }

    func setValidationStateDidChange(handler: @escaping (() -> Void), send controlEvent: UIControl.Event? = nil) {
        validationStateDidChangeHandler = handler
        setupControlEventListeners(send: controlEvent)
    }

    private func setupControlEventListeners(send controlEvent: UIControl.Event?) {
        addAction(for: .allEditingEvents) { [weak self] in
            guard let self = self else { return }
            self.validate()
        }
        addAction(for: .valueChanged) { [weak self] in
            guard let self = self else { return }
            self.validate()
        }

        if let controlEvent = controlEvent {
            self.sendActions(for: controlEvent)
        }
    }

    private func validate() {
        let previousFormState = self.validationState
        self.validationState = self.validationPredicate?() ?? .unknown
        if previousFormState != self.validationState {
            self.validationStateDidChangeHandler?()
            self.formFieldValidationDelegate?.formFieldValidationStateChanged()
        }
    }
}

private class ClosureWrapper {
    let closure: () -> Void

    init(closure: @escaping () -> Void) {
        self.closure = closure
    }

    @objc func invoke() {
        closure()
    }
}

private extension UIControl {
    func addAction(for controlEvents: UIControl.Event, action: @escaping () -> Void) {
        let wrapper = ClosureWrapper(closure: action)
        addTarget(wrapper, action: #selector(ClosureWrapper.invoke), for: controlEvents)
        objc_setAssociatedObject(self,
                                 "[\(arc4random())]",
                                 wrapper,
                                 .OBJC_ASSOCIATION_RETAIN)
    }
}
