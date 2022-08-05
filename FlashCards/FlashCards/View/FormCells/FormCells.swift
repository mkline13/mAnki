//
//  FormTitleCell.swift
//  FlashCards
//
//  Created by Work on 8/4/22.
//

import UIKit


class FormCellSingleLine: UITableViewCell, FormCell {
    // MARK: IB
    @IBOutlet private weak var textField: UITextField!
    
    @IBAction private func valueDidChange(_ sender: UITextField) {
        self.formField.value = textField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        delegate.formCell(self, fieldDidChange: self.formField)
    }
    
    // MARK: FormCell
    func configure(with field: FormField, delegate: FormCellDelegate) {
        self.formField = field
        self.delegate = delegate
        
        textField.placeholder = field.label
        textField.text = field.value
    }
    
    // MARK: Properties
    private var formField: FormField!
    private var delegate: FormCellDelegate!
}


class FormCellMultiline: UITableViewCell, UITextViewDelegate, FormCell {
    // MARK: IB
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var textView: UITextView!
    
    // MARK: UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        self.formField.value = textView.text?.trimmingCharacters(in: .whitespaces) ?? ""
        delegate.formCell(self, fieldDidChange: self.formField)
    }
    
    // MARK: FormCell
    func configure(with field: FormField, delegate: FormCellDelegate) {
        self.formField = field
        self.delegate = delegate
        
        label.text = field.label
        textView.text = field.value
    }
    
    // MARK: Properties
    private var formField: FormField!
    private var delegate: FormCellDelegate!
}


class FormCellSpacer: UITableViewCell, FormCell {
    func configure(with field: FormField, delegate: FormCellDelegate) {
        // Intentionally left blank
    }
}


class FormCellDisclosure: UITableViewCell, FormCell {
    // MARK: IB
    @IBOutlet private weak var label: UILabel!
    
    @IBAction private func click(coder: NSCoder) {
        print("Click")
    }
    
    // MARK: FormCell
    func configure(with field: FormField, delegate: FormCellDelegate) {
        self.formField = field
        self.delegate = delegate
        
        label.text = field.label
    }
    
    // MARK: Properties
    private var formField: FormField!
    private var delegate: FormCellDelegate!

//    var clickHandler: () -> Void
}
