//
//  File.swift
//  
//
//  Created by Dan_Koza on 8/15/21.
//

import UIKit

//MARK: - Subclasses of common UIControls that now adhere to FormFieldUIControl

open class UIFormFieldTextField: UITextField, FormFieldUIControl {
    public var validationTriggerEvents: [UIControl.Event] = [.allEditingEvents]
    public weak var formFieldValidationDelegate: FormFieldDelegate?
    public var validationPredicate: (() -> FormFieldValidationState)?
    public var validationStateDidChangeHandler: ((FormFieldValidationState) -> Void)?
    public var validationState: FormFieldValidationState = .default
    public var preValidationPredicate: (() -> Bool)?
}

open class UIFormFieldDatePicker: UIDatePicker, FormFieldUIControl {
    public var validationTriggerEvents: [UIControl.Event] = [.valueChanged]
    public weak var formFieldValidationDelegate: FormFieldDelegate?
    public var validationPredicate: (() -> FormFieldValidationState)?
    public var validationStateDidChangeHandler: ((FormFieldValidationState) -> Void)?
    public var validationState: FormFieldValidationState = .default
    public var preValidationPredicate: (() -> Bool)?
}

open class UIFormFieldSwitch: UISwitch, FormFieldUIControl {
    public var validationTriggerEvents: [UIControl.Event] = [.valueChanged]
    public weak var formFieldValidationDelegate: FormFieldDelegate?
    public var validationPredicate: (() -> FormFieldValidationState)?
    public var validationStateDidChangeHandler: ((FormFieldValidationState) -> Void)?
    public var validationState: FormFieldValidationState = .default
    public var preValidationPredicate: (() -> Bool)?
}

open class UIFormFieldButton: UIButton, FormFieldUIControl {
    public var validationTriggerEvents: [UIControl.Event] = [.touchUpInside]
    public weak var formFieldValidationDelegate: FormFieldDelegate?
    public var validationPredicate: (() -> FormFieldValidationState)?
    public var validationStateDidChangeHandler: ((FormFieldValidationState) -> Void)?
    public var validationState: FormFieldValidationState = .default
    public var preValidationPredicate: (() -> Bool)?
}

open class UIFormFieldSegmentedControl: UISegmentedControl, FormFieldUIControl {
    public var validationTriggerEvents: [UIControl.Event] = [.valueChanged]
    public weak var formFieldValidationDelegate: FormFieldDelegate?
    public var validationPredicate: (() -> FormFieldValidationState)?
    public var validationStateDidChangeHandler: ((FormFieldValidationState) -> Void)?
    public var validationState: FormFieldValidationState = .default
    public var preValidationPredicate: (() -> Bool)?
}

open class UIFormFieldSlider: UISlider, FormFieldUIControl {
    public var validationTriggerEvents: [UIControl.Event] = [.valueChanged]
    public weak var formFieldValidationDelegate: FormFieldDelegate?
    public var validationPredicate: (() -> FormFieldValidationState)?
    public var validationStateDidChangeHandler: ((FormFieldValidationState) -> Void)?
    public var validationState: FormFieldValidationState = .default
    public var preValidationPredicate: (() -> Bool)?
}

open class UIFormFieldStepper: UIStepper, FormFieldUIControl {
    public var validationTriggerEvents: [UIControl.Event] = [.valueChanged]
    public weak var formFieldValidationDelegate: FormFieldDelegate?
    public var validationPredicate: (() -> FormFieldValidationState)?
    public var validationStateDidChangeHandler: ((FormFieldValidationState) -> Void)?
    public var validationState: FormFieldValidationState = .default
    public var preValidationPredicate: (() -> Bool)?
}

@available(iOS 14.0, *)
open class UIFormFieldColorWell: UIColorWell, FormFieldUIControl {
    public var validationTriggerEvents: [UIControl.Event] = [.valueChanged]
    public weak var formFieldValidationDelegate: FormFieldDelegate?
    public var validationPredicate: (() -> FormFieldValidationState)?
    public var validationStateDidChangeHandler: ((FormFieldValidationState) -> Void)?
    public var validationState: FormFieldValidationState = .default
    public var preValidationPredicate: (() -> Bool)?
}
