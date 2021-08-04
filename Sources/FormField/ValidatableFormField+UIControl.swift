//
//  File.swift
//  
//
//  Created by Dan Koza on 7/26/21.
//

import UIKit

public protocol ValidatableUIControl: ValidatableFormField where Self: UIControl {
    /// Validates the form field when the control sends one of the `validationControlEvents`.
    var validationControlEvents: [UIControl.Event] { get }
}

public extension ValidatableUIControl {

    /// Initializes a `ValidatableFormField` for a `UIControl`
    /// - Parameters:
    ///   - validationPredicate: Logic  to determine when the `ValidatableFormField`'s `FormFieldValidationState`. This predicate is executed when the `UIControl` sends a `controlEvent`
    ///   - validationStateDidChangeHandler: Callback handler that used to trigger events when the `ValidatableFormField`'s `FormFieldValidationState` changes
    ///   - runValidation: After initializtion, this `BOOL` will execute the `validationPredicate`once.
    init(validationPredicate: (() -> FormFieldValidationState)?,
         validationStateDidChangeHandler: ((FormFieldValidationState) -> Void)?,
         runValidation: Bool = false) {

        self.init(frame: .zero)
        self.validationPredicate = validationPredicate
        self.validationStateDidChangeHandler = validationStateDidChangeHandler

        listen(for: validationControlEvents)

        if runValidation {
            validate()
        }
    }

    /// Sets the `validationPredicate`
    /// - Parameters:
    ///   - predicate: Logic  to determine when the `ValidatableFormField`'s `FormFieldValidationState`. This predicate is executed when the `UIControl` sends a `controlEvent`
    func setValidation(predicate: @escaping () -> FormFieldValidationState) {
        validationPredicate = predicate
        listen(for: validationControlEvents)
    }

    /// Sets the `validationStateDidChangeHandler`
    /// - Parameter handler: Callback handler that used to trigger events when the `ValidatableFormField`'s `FormFieldValidationState` changes
    func setValidationStateDidChange(handler: @escaping ((FormFieldValidationState) -> Void)) {
        validationStateDidChangeHandler = handler
    }

    func validate() {
        let previousFormState = self.validationState
        self.validationState = self.validationPredicate?() ?? .unknown

        if previousFormState != self.validationState {
            self.validationStateDidChangeHandler?(self.validationState)
            self.formFieldValidationDelegate?.formFieldValidationStateChanged()
        }
    }

    private func listen(for controlEvents: [UIControl.Event]) {
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
private class ClosureWrapper {
    let closure: () -> Void

    init(closure: @escaping () -> Void) {
        self.closure = closure
    }

    @objc func invoke() {
        closure()
    }
}

private class ClosureWrapperContainer {
    static let shared = ClosureWrapperContainer()
    private(set) var closureWrappers: [UIControl: [ClosureWrapper]] = [:]

    func append(_ closureWrapper: ClosureWrapper, tiedTo control: UIControl) {
        closureWrappers[control]?.append(closureWrapper)
    }

//    func clear

//    @objc func invoke() {
//        closure()
//    }
}

private extension UIControl {
    func addAction(for controlEvents: UIControl.Event, action: @escaping () -> Void) {
        objc_removeAssociatedObjects(self)

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

//open class UIFormTextField: UITextField, ValidatableUIControl {
//    public var validationControlEvents: [UIControl.Event] { [.allEditingEvents] }
//    public weak var formFieldValidationDelegate: FormFieldValidationDelegate?
//    public var validationPredicate: (() -> FormFieldValidationState)?
//    public var validationStateDidChangeHandler: ((FormFieldValidationState) -> Void)?
//    public var validationState: FormFieldValidationState = .unknown
//}
//
//open class UIFormDatePicker: UIDatePicker, ValidatableUIControl {
//    public var validationControlEvents: [UIControl.Event] { [.valueChanged] }
//    public weak var formFieldValidationDelegate: FormFieldValidationDelegate?
//    public var validationPredicate: (() -> FormFieldValidationState)?
//    public var validationStateDidChangeHandler: ((FormFieldValidationState) -> Void)?
//    public var validationState: FormFieldValidationState = .unknown
//}
//
//open class UIFormSwitch: UISwitch, ValidatableUIControl {
//    public var validationControlEvents: [UIControl.Event] { [.valueChanged] }
//    public weak var formFieldValidationDelegate: FormFieldValidationDelegate?
//    public var validationPredicate: (() -> FormFieldValidationState)?
//    public var validationStateDidChangeHandler: ((FormFieldValidationState) -> Void)?
//    public var validationState: FormFieldValidationState = .unknown
//}
//
//open class UIFormButton: UIButton, ValidatableUIControl {
//    public var validationControlEvents: [UIControl.Event] { [.allEvents] }
//    public weak var formFieldValidationDelegate: FormFieldValidationDelegate?
//    public var validationPredicate: (() -> FormFieldValidationState)?
//    public var validationStateDidChangeHandler: ((FormFieldValidationState) -> Void)?
//    public var validationState: FormFieldValidationState = .unknown
//}
//
//open class UIFormSegmentedControl: UISegmentedControl, ValidatableUIControl {
//    public var validationControlEvents: [UIControl.Event] { [.valueChanged] }
//    public weak var formFieldValidationDelegate: FormFieldValidationDelegate?
//    public var validationPredicate: (() -> FormFieldValidationState)?
//    public var validationStateDidChangeHandler: ((FormFieldValidationState) -> Void)?
//    public var validationState: FormFieldValidationState = .unknown
//}
//
//open class UIFormSlider: UISlider, ValidatableUIControl {
//    public var validationControlEvents: [UIControl.Event] { [.valueChanged] }
//    public weak var formFieldValidationDelegate: FormFieldValidationDelegate?
//    public var validationPredicate: (() -> FormFieldValidationState)?
//    public var validationStateDidChangeHandler: ((FormFieldValidationState) -> Void)?
//    public var validationState: FormFieldValidationState = .unknown
//}
//
//open class UIFormStepper: UIStepper, ValidatableUIControl {
//    public var validationControlEvents: [UIControl.Event] { [.valueChanged] }
//    public weak var formFieldValidationDelegate: FormFieldValidationDelegate?
//    public var validationPredicate: (() -> FormFieldValidationState)?
//    public var validationStateDidChangeHandler: ((FormFieldValidationState) -> Void)?
//    public var validationState: FormFieldValidationState = .unknown
//}
//
//@available(iOS 14.0, *)
//open class UIFormColorWell: UIColorWell, ValidatableUIControl {
//    public var validationControlEvents: [UIControl.Event] { [.valueChanged] }
//    public weak var formFieldValidationDelegate: FormFieldValidationDelegate?
//    public var validationPredicate: (() -> FormFieldValidationState)?
//    public var validationStateDidChangeHandler: ((FormFieldValidationState) -> Void)?
//    public var validationState: FormFieldValidationState = .unknown
//}
