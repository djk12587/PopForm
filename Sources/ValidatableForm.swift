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
    private var wasValid: Bool?

    public var isValid: Bool { !formFields.contains { !($0.validationPredicate?() == .valid) } }

    public init(fields: ValidatableFormField..., delegate: ValidatableFormDelegate? = nil) {
        self.formFields = fields
        self.delegate = delegate
        formFields.forEach { $0.formFieldValidationDelegate = self }
    }

    public func set(delegate: ValidatableFormDelegate) {
        self.delegate = delegate
    }

    private func validateForm() {
        defer {
            wasValid = isValid
        }

        let isValid = isValid
        if wasValid != isValid {
            delegate?.formValidationChanged(formIsValid: isValid)
        }
    }
}

extension ValidatableForm: FormFieldValidationDelegate {
    public func formFieldValidationStateChanged() {
        validateForm()
    }
}
