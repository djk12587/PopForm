//
//  File.swift
//  
//
//  Created by Dan Koza on 7/26/21.
//

import UIKit

public protocol ValidatableFormDelegate: AnyObject {
    func formValidationChanged(formIsValid: Bool)
}

public class ValidatableForm {

    private let formFields: [ValidatableFormField]
    private weak var delegate: ValidatableFormDelegate?
    private lazy var savedValidity: Bool = { isValid }()

    public var isValid: Bool { !formFields.contains(where: { !($0.validator?() == .valid) }) }

    public init(fields: ValidatableFormField..., delegate: ValidatableFormDelegate? = nil) {
        self.formFields = fields
        self.delegate = delegate
        setupFormFieldValidityDelegates()
        formFields.forEach { $0.validationListener = self }
    }

    public func set(delegate: ValidatableFormDelegate) {
        self.delegate = delegate
    }

    private func setupFormFieldValidityDelegates() {
        formFields.forEach { $0.validationListener = self }
    }

    private func validateForm() {
        defer {
            savedValidity = isValid
        }

        let isValid = isValid
        if savedValidity != isValid {
            delegate?.formValidationChanged(formIsValid: isValid)
        }
    }
}

extension ValidatableForm: FormFieldValidationListener {
    public func validatableFormFieldWasEdited() {
        validateForm()
    }
}
