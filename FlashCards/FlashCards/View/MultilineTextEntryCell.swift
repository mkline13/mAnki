//
//  TextEntryCell.swift
//  FlashCards
//
//  Created by Work on 8/1/22.
//

import UIKit


class MultilineTextEntryCell: UITableViewCell, FormFieldCell, UITextViewDelegate {
    // MARK: Properties
    static let reuseIdentifier: String = "MultilineTextEntryCell"
    private var fieldIndex: Int!
    var delegate: FormFieldCellDelegate!
    
    // MARK: IB
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var input: UITextView!
    
    func textViewDidChange(_ textView: UITextView) {
        delegate.formFieldCell(self, valueDidChange: textView.text ?? "", fieldIndex: self.fieldIndex)
    }
    
    // MARK: FormFieldCell
    func configure(fieldIndex index: Int, labelText: String, delegate: FormFieldCellDelegate) {
        self.selectionStyle = .none
        
        self.fieldIndex = index
        self.label.text = labelText
        self.delegate = delegate
    }
    
    // MARK: UI
    override func awakeFromNib() {
        input.textContainerInset.left = 0
        input.isEditable = true
    }
}
