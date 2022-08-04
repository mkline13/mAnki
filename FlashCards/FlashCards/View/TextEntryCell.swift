//
//  TextEntryCell.swift
//  FlashCards
//
//  Created by Work on 8/1/22.
//

import UIKit


class TextEntryCell: UITableViewCell, FormFieldCell, UITextFieldDelegate {
    // MARK: Properties
    static let reuseIdentifier: String = "TextEntryCell"
    private var fieldIndex: Int!
    var delegate: FormFieldCellDelegate!
    
    // MARK: IB
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var input: UITextField!
    
    @IBAction private func valueDidChange(_ sender: UITextField) {
        delegate.formFieldCell(self, valueDidChange: input.text ?? "", fieldIndex: self.fieldIndex)
    }
    
    // MARK: FormFieldCell
    func configure(fieldIndex index: Int, labelText: String, delegate: FormFieldCellDelegate) {
        self.selectionStyle = .none
        
        self.fieldIndex = index
        self.label.text = labelText
        self.delegate = delegate
    }
}
