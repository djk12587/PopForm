//
//  File.swift
//  
//
//  Created by Dan_Koza on 7/28/21.
//

import UIKit

open class UIFormTextField: UITextField, ValidatableFormField {
    public weak var formFieldValidationDelegate: FormFieldValidationDelegate?
    public var validationPredicate: (() -> FormFieldValidationState)?
    public var validationStateDidChangeHandler: (() -> Void)?
    public var validationState: FormFieldValidationState = .unknown
}

open class UIFormDatePicker: UIDatePicker, ValidatableFormField {
    public weak var formFieldValidationDelegate: FormFieldValidationDelegate?
    public var validationPredicate: (() -> FormFieldValidationState)?
    public var validationStateDidChangeHandler: (() -> Void)?
    public var validationState: FormFieldValidationState = .unknown
}

open class UIFormSwitch: UISwitch, ValidatableFormField {
    public weak var formFieldValidationDelegate: FormFieldValidationDelegate?
    public var validationPredicate: (() -> FormFieldValidationState)?
    public var validationStateDidChangeHandler: (() -> Void)?
    public var validationState: FormFieldValidationState = .unknown
}

//class UIFormButton: UIButton, ValidatableFormField {
//    internal var validationState: FormFieldValidationState = .unknown
//    internal var validator: (() -> FormFieldValidationState)?
//}
//
//class UIFormSwitch: UISwitch, ValidatableFormField {
//    internal var validationState: FormFieldValidationState = .unknown
//    internal var validator: (() -> FormFieldValidationState)?
//}
//
//class UIFormSegmentedControl: UISegmentedControl, ValidatableFormField {
//    internal var validationState: FormFieldValidationState = .unknown
//    internal var validator: (() -> FormFieldValidationState)?
//}
//
//class UIFormSlider: UISlider, ValidatableFormField {
//    internal var validationState: FormFieldValidationState = .unknown
//    internal var validator: (() -> FormFieldValidationState)?
//}
//
//class UIFormStepper: UIStepper, ValidatableFormField {
//    internal var validationState: FormFieldValidationState = .unknown
//    internal var validator: (() -> FormFieldValidationState)?
//}
