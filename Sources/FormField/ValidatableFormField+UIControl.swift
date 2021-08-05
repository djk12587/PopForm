//
//  File.swift
//  
//
//  Created by Dan Koza on 7/26/21.
//

import UIKit

public protocol ValidatableUIControl: ValidatableFormField where Self: UIControl {
    /// Validates the form field when the control sends one of the `validationTriggerEvents`.
    var validationTriggerEvents: [UIControl.Event] { get set }
}

public extension ValidatableUIControl {

    /// Initializes a `ValidatableFormField` for a `UIControl`. After initialization, the `validationPredicate` & `validationStateDidChangeHandler` are always executed once.
    /// - Parameters:
    ///   - validationPredicate: Logic  to determine when the `ValidatableFormField`'s `FormFieldValidationState`. This predicate is executed when the `UIControl` sends a `controlEvent`
    ///   - validationStateDidChangeHandler: Callback handler that used to trigger events when the `ValidatableFormField`'s `FormFieldValidationState` changes
    init(validationPredicate: @escaping () -> FormFieldValidationState,
         validationStateDidChangeHandler: ((FormFieldValidationState) -> Void)? = nil) {

        self.init(frame: .zero)
        self.validationPredicate = validationPredicate
        self.validationStateDidChangeHandler = validationStateDidChangeHandler

        listen(for: validationTriggerEvents)
        let validationStateDidChange = validate()
        if !validationStateDidChange {
            validationStateDidChangeHandler?(validationState)
        }
    }

    func set(validationTriggerEvents: UIControl.Event...) {
        self.validationTriggerEvents = validationTriggerEvents
        listen(for: validationTriggerEvents)
    }

    /// Clears existing validationPredicates and sets up a brand new `validationPredicate`. The predicate is executed before `setValidation(predicate:)` finishes.
    /// - Parameters:
    ///   - predicate: Logic  to determine when the `ValidatableFormField`'s `FormFieldValidationState`. This predicate is executed when the `UIControl` sends a `controlEvent`
    func setValidation(predicate: @escaping () -> FormFieldValidationState) {
        validationPredicate = predicate
        listen(for: validationTriggerEvents)
        validate()
    }

    /// Sets the `validationStateDidChangeHandler`. The handler is executed before `setValidationStateDidChange(handler:)` finishes
    /// - Parameter handler: Callback handler that used to trigger events when the `ValidatableFormField`'s `FormFieldValidationState` changes
    func setValidationStateDidChange(handler: @escaping ((FormFieldValidationState) -> Void)) {
        validationStateDidChangeHandler = handler
        handler(validationState)
    }

    /// Runs the validation
    /// - Returns: A `Bool` indicating if the validationState did change
    @discardableResult
    func validate() -> Bool {

        let previousFormState = validationState
        validationState = validationPredicate?() ?? .unknown

        let validationStateDidChange = previousFormState != validationState
        if validationStateDidChange {
            validationStateDidChangeHandler?(validationState)
            formFieldValidationDelegate?.formFieldValidationStateChanged()
        }
        return validationStateDidChange
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
                self.validate()
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

//MARK: - Subclasses of common UIControls that now adhere to ValidatableUIControl

open class UIFormTextField: UITextField, ValidatableUIControl {
    public var validationTriggerEvents: [UIControl.Event] = [.allEditingEvents]
    public weak var formFieldValidationDelegate: FormFieldValidationDelegate?
    public var validationPredicate: (() -> FormFieldValidationState)?
    public var validationStateDidChangeHandler: ((FormFieldValidationState) -> Void)?
    public var validationState: FormFieldValidationState = .default
}

open class UIFormDatePicker: UIDatePicker, ValidatableUIControl {
    public var validationTriggerEvents: [UIControl.Event] = [.valueChanged]
    public weak var formFieldValidationDelegate: FormFieldValidationDelegate?
    public var validationPredicate: (() -> FormFieldValidationState)?
    public var validationStateDidChangeHandler: ((FormFieldValidationState) -> Void)?
    public var validationState: FormFieldValidationState = .default
}

open class UIFormSwitch: UISwitch, ValidatableUIControl {
    public var validationTriggerEvents: [UIControl.Event] = [.valueChanged]
    public weak var formFieldValidationDelegate: FormFieldValidationDelegate?
    public var validationPredicate: (() -> FormFieldValidationState)?
    public var validationStateDidChangeHandler: ((FormFieldValidationState) -> Void)?
    public var validationState: FormFieldValidationState = .default
}

open class UIFormButton: UIButton, ValidatableUIControl {
    public var validationTriggerEvents: [UIControl.Event] = [.touchUpInside]
    public weak var formFieldValidationDelegate: FormFieldValidationDelegate?
    public var validationPredicate: (() -> FormFieldValidationState)?
    public var validationStateDidChangeHandler: ((FormFieldValidationState) -> Void)?
    public var validationState: FormFieldValidationState = .default
}

open class UIFormSegmentedControl: UISegmentedControl, ValidatableUIControl {
    public var validationTriggerEvents: [UIControl.Event] = [.valueChanged]
    public weak var formFieldValidationDelegate: FormFieldValidationDelegate?
    public var validationPredicate: (() -> FormFieldValidationState)?
    public var validationStateDidChangeHandler: ((FormFieldValidationState) -> Void)?
    public var validationState: FormFieldValidationState = .default
}

open class UIFormSlider: UISlider, ValidatableUIControl {
    public var validationTriggerEvents: [UIControl.Event] = [.valueChanged]
    public weak var formFieldValidationDelegate: FormFieldValidationDelegate?
    public var validationPredicate: (() -> FormFieldValidationState)?
    public var validationStateDidChangeHandler: ((FormFieldValidationState) -> Void)?
    public var validationState: FormFieldValidationState = .default
}

open class UIFormStepper: UIStepper, ValidatableUIControl {
    public var validationTriggerEvents: [UIControl.Event] = [.valueChanged]
    public weak var formFieldValidationDelegate: FormFieldValidationDelegate?
    public var validationPredicate: (() -> FormFieldValidationState)?
    public var validationStateDidChangeHandler: ((FormFieldValidationState) -> Void)?
    public var validationState: FormFieldValidationState = .default
}

@available(iOS 14.0, *)
open class UIFormColorWell: UIColorWell, ValidatableUIControl {
    public var validationTriggerEvents: [UIControl.Event] = [.valueChanged]
    public weak var formFieldValidationDelegate: FormFieldValidationDelegate?
    public var validationPredicate: (() -> FormFieldValidationState)?
    public var validationStateDidChangeHandler: ((FormFieldValidationState) -> Void)?
    public var validationState: FormFieldValidationState = .default
}
