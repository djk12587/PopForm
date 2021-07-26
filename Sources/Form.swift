//
//  File.swift
//  
//
//  Created by Dan Koza on 7/26/21.
//

import UIKit

public protocol FormDelegate: AnyObject {
    associatedtype TextFormField: UITextField & FormField
    func textFormFieldStateChanged(textFormField: TextFormField)
    func formValidationChanged(allTextFormFieldsAreValidated: Bool)
}

public class Form<TextFormField, Delegate: FormDelegate> where TextFormField == Delegate.TextFormField{

    public let formFields: [TextFormField]
    private weak var delegate: Delegate?

    public var isValid: Bool { !formFields.contains(where: { !$0.isValid }) }

    public init(formFields: TextFormField..., delegate: Delegate? = nil) {
        self.formFields = formFields
        self.delegate = delegate

        formFields.forEach {
            $0.addTarget(self,
                         action: #selector(textFormFieldTextChanged(textField:)),
                         for: .editingChanged)
        }
    }

    public func set(delegate: Delegate) {
        self.delegate = delegate
    }

    @objc final private func textFormFieldTextChanged(textField: UITextField) {
        guard
            var textFormField = formFields.first(where: { $0 === textField })
        else { return }

        textFormField.formatter.format(textField: textFormField)
        validate(textFormField: &textFormField)
    }

    private func validate(textFormField: inout TextFormField) {

        let previousValidationState = textFormField.validationState

        let text = textFormField.text ?? ""
        if text.isEmpty {
            textFormField.validationState = .empty
        }
        else {
            textFormField.validationState = textFormField.validator.validate(text: text)
        }

        if previousValidationState != textFormField.validationState {
            delegate?.textFormFieldStateChanged(textFormField: textFormField)
            checkFormFieldsValidationState()
        }
    }

    private func checkFormFieldsValidationState() {
        let allTextFormFieldsAreValidated = !formFields.contains(where: { $0.validationState != .valid })
        delegate?.formValidationChanged(allTextFormFieldsAreValidated: allTextFormFieldsAreValidated)
    }
}
