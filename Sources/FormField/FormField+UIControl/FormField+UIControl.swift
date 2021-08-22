//
//  File.swift
//  
//
//  Created by Dan Koza on 7/26/21.
//

import UIKit

public protocol FormFieldUIControl: FormField where Self: UIControl {
    /// Validates the form field when the control sends one of the `validationTriggerEvents`.
    var validationTriggerEvents: [UIControl.Event] { get set }
}

public extension FormFieldUIControl {

    /// Initializes a `ValidatableFormField` for a `UIControl`. After initialization, the `validationPredicate` & `validationStateDidChangeHandler` are always executed once.
    /// - Parameters:
    ///   - preValidationPredicate: The predicate is executed before the `validationPredicate` is ran. If false is returned, then the `validationPredicate` is not ran.
    ///   - validationPredicate: Logic  to determine when the `ValidatableFormField`'s `FormFieldValidationState`. This predicate is executed when the `UIControl` sends a `controlEvent`
    ///   - validationStateDidChangeHandler: Callback handler that used to trigger events when the `ValidatableFormField`'s `FormFieldValidationState` changes
    init(preValidationPredicate: (() -> Bool)? = nil,
         validationPredicate: @escaping () -> FormFieldValidationState,
         validationStateDidChangeHandler: ((FormFieldValidationState) -> Void)? = nil) {

        self.init(frame: .zero)
        self.preValidationPredicate = preValidationPredicate
        self.validationPredicate = validationPredicate
        self.validationStateDidChangeHandler = validationStateDidChangeHandler

        listen(for: validationTriggerEvents)
        let validationStateDidChange = validationNeeded()
        if !validationStateDidChange {
            validationStateDidChangeHandler?(validationState)
        }
    }

    /// Clears existing validationPredicates and sets up a brand new `validationPredicate`. The predicate is executed before `setValidation(predicate:)` finishes.
    /// - Parameters:
    ///   - predicate: Logic  to determine when the `ValidatableFormField`'s `FormFieldValidationState`. This predicate is executed when the `UIControl` sends a `controlEvent`
    func setValidation(predicate: @escaping () -> FormFieldValidationState) {
        validationPredicate = predicate
        listen(for: validationTriggerEvents)
        validationNeeded()
    }

    //Removes existing targets that were added by addAction(for controlEvents:, action:)
    private func removeExistingListeners() {
        objc_removeAssociatedObjects(self)
    }

    private func listen(for controlEvents: [UIControl.Event]) {
        removeExistingListeners()

        controlEvents.forEach { event in
            addAction(for: event) { [weak self] in
                guard let self = self else { return }
                self.validationNeeded()
            }
        }
    }
}

//MARK: - Workaround for setting up an action when a UIControl.Event is sent on a UIControl
//Trying to call addTarget in a protocol extension causues a lot of issues with due to the @objc requirement
//Workaround source - https://blog.natanrolnik.me/protocols-default-impl-control-handling
private extension UIControl {
    func addAction(for controlEvents: UIControl.Event, action: @escaping () -> Void) {
        let wrapper = ClosureWrapper(closure: action)
        addTarget(wrapper, action: #selector(ClosureWrapper.invoke), for: controlEvents)
        ///"Because `wrapper` was created in the function scope, it would go away at the end of the function. To avoid that, we attach it to the `UIControl` itself using `objc_setAssociatedObject` - so whenever the `UIControl` is alive, the `wrapper` we just created will be kept in the memory as well." - https://blog.natanrolnik.me/protocols-default-impl-control-handling
        objc_setAssociatedObject(self,
                                 "[\(arc4random())]",
                                 wrapper,
                                 .OBJC_ASSOCIATION_RETAIN)
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
