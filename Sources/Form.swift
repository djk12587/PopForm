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

public class Form {

    private var formFields: [FormField]
    private weak var delegate: ValidatableFormDelegate?
    private var wasValid: Bool?

    public var isValid: Bool { !formFields.contains { !($0.validationState == .valid) } }

    public init(fields: FormField..., delegate: ValidatableFormDelegate? = nil) {
        self.formFields = fields
        self.delegate = delegate
        formFields.forEach { $0.formFieldValidationDelegate = self }
    }

    public func set(delegate: ValidatableFormDelegate) {
        self.delegate = delegate
    }

    public func remove(fields: FormField...) {
        fields.forEach { fieldToRemove in
            fieldToRemove.formFieldValidationDelegate = nil
            formFields.removeAll { $0 === fieldToRemove }
        }
        validateForm()
    }

    public func add(fields: FormField...) {
        fields.forEach { $0.formFieldValidationDelegate = self }
        formFields.append(contentsOf: fields)
        validateForm()
    }

    public func replace(with fields: FormField...) {
        formFields.forEach { $0.formFieldValidationDelegate = nil }
        formFields.removeAll()

        fields.forEach { $0.formFieldValidationDelegate = self }
        formFields = fields
        validateForm()
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

extension Form: FormFieldDelegate {
    public func formFieldValidationStateChanged() {
        validateForm()
    }
}
