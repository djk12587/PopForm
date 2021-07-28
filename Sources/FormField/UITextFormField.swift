//
//  File.swift
//  
//
//  Created by Dan Koza on 7/26/21.
//

import UIKit

//struct Shit: FormFieldValidator {
//
//    func validate(contents: Data) -> FormFieldValidationState {
//        return .empty
//    }
//
//
//
//
//
//}
//
//func test() {
////    let idkWhatThisIs = This<Shit>(validator: Shit())
////    let ass = idkWhatThisIs.validator.validate(contents: Data())
////    print(ass)
//
//}

open class UIFormTextField: UITextField, ValidatableFormField {
    weak public var validationListener: FormFieldValidationListener?
    public var validator: (() -> FormFieldValidationState)?
    public var validationState: FormFieldValidationState = .unknown {
        didSet {
            guard validationState != oldValue else { return }
            validationStateDidChange()
        }
    }

    open func validationStateDidChange() {}
}

open class UIFormDatePicker: UIDatePicker, ValidatableFormField {
    public weak var validationListener: FormFieldValidationListener?
    public var validator: (() -> FormFieldValidationState)?
    public var validationState: FormFieldValidationState = .unknown {
        didSet {
            guard validationState != oldValue else { return }
            validationStateDidChange()
        }
    }

    open func validationStateDidChange() {}
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
