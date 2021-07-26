//
//  File.swift
//  
//
//  Created by Dan Koza on 7/26/21.
//

import UIKit

public class UITextFormField: UITextField, FormField {

    public let formatter: FormFieldFormatter
    public let validator: FormFieldValidator
    public var validationState: FormFieldValidationState = .empty

    public init(validator: FormFieldValidator, formatter: FormFieldFormatter) {
        self.validator = validator
        self.formatter = formatter
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        //TODO: - support xib inits?
        fatalError("init(coder:) has not been implemented")
    }
}
