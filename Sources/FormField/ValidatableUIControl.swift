//
//  File.swift
//  
//
//  Created by Dan Koza on 7/26/21.
//

import UIKit

///Default implementation of a `ValidatableUIControl`
public protocol ValidatableUIControl: ValidatableFormField where Self: UIControl {
    /// The default `UIControl.Event` to listen to for validation changes
    var defaultValidationControlEvent: UIControl.Event { get }
}

public extension ValidatableUIControl {

    /// Initializes a `ValidatableFormField` for a `UIControl`
    /// - Parameters:
    ///   - validationPredicate: Logic  to determine when the `ValidatableFormField`'s `FormFieldValidationState`. This predicate is executed when the `UIControl` sends a `controlEvent`
    ///   - validationStateDidChangeHandler: Callback handler that used to trigger events when the `ValidatableFormField`'s `FormFieldValidationState` changes
    ///   - controlEvent: Validates the form field when the control sends a `controlEvent`. If you pass in nil, the `defaultValidationControlEvent` will be used
    ///   - runValidation: After initializtion, this `BOOL` will execute the `validationPredicate`once.
    init(validationPredicate: (() -> FormFieldValidationState)?,
         validationStateDidChangeHandler: (() -> Void)?,
         validateOn controlEvent: UIControl.Event? = nil,
         runValidation: Bool = false) {

        self.init(frame: .zero)
        self.validationPredicate = validationPredicate
        self.validationStateDidChangeHandler = validationStateDidChangeHandler
        listen(for: controlEvent ?? defaultValidationControlEvent, sendEvent: runValidation)
    }

    /// Sets the `validationPredicate`
    /// - Parameters:
    ///   - predicate: Logic  to determine when the `ValidatableFormField`'s `FormFieldValidationState`. This predicate is executed when the `UIControl` sends a `controlEvent`
    ///   - controlEvent: Validates the form field when the control sends a `controlEvent`. If you pass in nil, the `defaultValidationControlEvent` will be used
    ///   - runValidation: After initializtion, this `BOOL` will execute the validation `predicate`once.
    func setValidation(predicate: @escaping () -> FormFieldValidationState, for controlEvent: UIControl.Event? = nil, runValidation: Bool = false) {
        validationPredicate = predicate
        listen(for: controlEvent ?? defaultValidationControlEvent, sendEvent: runValidation)
    }

    /// Sets the `validationStateDidChangeHandler`
    /// - Parameter handler: Callback handler that used to trigger events when the `ValidatableFormField`'s `FormFieldValidationState` changes
    func setValidationStateDidChange(handler: @escaping (() -> Void)) {
        validationStateDidChangeHandler = handler
    }

    private func listen(for controlEvent: UIControl.Event, sendEvent: Bool) {
        addAction(for: controlEvent) { [weak self] in
            guard let self = self else { return }
            self.validate()
        }

        if sendEvent {
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

//MARK: - Workaround for setting up an action when a UIControl.Event is sent on a UIControl
//Trying to call addTarget in a protocol extension causues a lot of issues with due to the @objc requirement
//Workaround source - https://blog.natanrolnik.me/protocols-default-impl-control-handling
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
        ///"Because `wrapper` was created in the function scope, it would go away at the end of the function. To avoid that, we attach it to the `UIControl` itself using `objc_setAssociatedObject` - so whenever the `UIControl` is alive, the `wrapper` we just created will be kept in the memory as well." - https://blog.natanrolnik.me/protocols-default-impl-control-handling
        objc_setAssociatedObject(self,
                                 "[\(arc4random())]",
                                 wrapper,
                                 .OBJC_ASSOCIATION_RETAIN)
    }
}

//MARK: - Subclasses of common UIControls that now adhere to ValidatableUIControl

open class UIFormTextField: UITextField, ValidatableUIControl {
    public var defaultValidationControlEvent: UIControl.Event { .allEditingEvents }
    public weak var formFieldValidationDelegate: FormFieldValidationDelegate?
    public var validationPredicate: (() -> FormFieldValidationState)?
    public var validationStateDidChangeHandler: (() -> Void)?
    public var validationState: FormFieldValidationState = .unknown
}

open class UIFormDatePicker: UIDatePicker, ValidatableUIControl {
    public var defaultValidationControlEvent: UIControl.Event { .valueChanged }
    public weak var formFieldValidationDelegate: FormFieldValidationDelegate?
    public var validationPredicate: (() -> FormFieldValidationState)?
    public var validationStateDidChangeHandler: (() -> Void)?
    public var validationState: FormFieldValidationState = .unknown
}

open class UIFormSwitch: UISwitch, ValidatableUIControl {
    public var defaultValidationControlEvent: UIControl.Event { .valueChanged }
    public weak var formFieldValidationDelegate: FormFieldValidationDelegate?
    public var validationPredicate: (() -> FormFieldValidationState)?
    public var validationStateDidChangeHandler: (() -> Void)?
    public var validationState: FormFieldValidationState = .unknown
}

open class UIFormButton: UIButton, ValidatableUIControl {
    public var defaultValidationControlEvent: UIControl.Event { .allEvents }
    public weak var formFieldValidationDelegate: FormFieldValidationDelegate?
    public var validationPredicate: (() -> FormFieldValidationState)?
    public var validationStateDidChangeHandler: (() -> Void)?
    public var validationState: FormFieldValidationState = .unknown
}

open class UIFormSegmentedControl: UISegmentedControl, ValidatableUIControl {
    public var defaultValidationControlEvent: UIControl.Event { .valueChanged }
    public weak var formFieldValidationDelegate: FormFieldValidationDelegate?
    public var validationPredicate: (() -> FormFieldValidationState)?
    public var validationStateDidChangeHandler: (() -> Void)?
    public var validationState: FormFieldValidationState = .unknown
}

open class UIFormSlider: UISlider, ValidatableUIControl {
    public var defaultValidationControlEvent: UIControl.Event { .valueChanged }
    public weak var formFieldValidationDelegate: FormFieldValidationDelegate?
    public var validationPredicate: (() -> FormFieldValidationState)?
    public var validationStateDidChangeHandler: (() -> Void)?
    public var validationState: FormFieldValidationState = .unknown
}

open class UIFormStepper: UIStepper, ValidatableUIControl {
    public var defaultValidationControlEvent: UIControl.Event { .valueChanged }
    public weak var formFieldValidationDelegate: FormFieldValidationDelegate?
    public var validationPredicate: (() -> FormFieldValidationState)?
    public var validationStateDidChangeHandler: (() -> Void)?
    public var validationState: FormFieldValidationState = .unknown
}

@available(iOS 14.0, *)
open class UIFormColorWell: UIColorWell, ValidatableUIControl {
    public var defaultValidationControlEvent: UIControl.Event { .valueChanged }
    public weak var formFieldValidationDelegate: FormFieldValidationDelegate?
    public var validationPredicate: (() -> FormFieldValidationState)?
    public var validationStateDidChangeHandler: (() -> Void)?
    public var validationState: FormFieldValidationState = .unknown
}
