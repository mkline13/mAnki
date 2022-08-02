//
//  TextEntryCell.swift
//  FlashCards
//
//  Created by Work on 8/1/22.
//

import UIKit


class MultilineTextEntryCell: UITableViewCell, UITextViewDelegate {
    static let cellIdentifier = "MultilineTextEntryCell"
    
    // MARK: Properties
    var fieldIdentifier: String!
    var placeholderText: String!
    private var inputFieldHasText: Bool = false
    
    @IBOutlet private weak var inputField: UITextView!
    
    // MARK: UI
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        inputField.isEditable = true
    }
    
    func configure(fieldIdentifier identifier: String, placeholderText placeholder: String? = nil) {
        self.fieldIdentifier = identifier
        self.placeholderText = placeholder ?? identifier
        
        setTextField()
    }
    
    // MARK: TextViewDelegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if !inputFieldHasText {
            inputField.text = nil
            inputField.textColor = UIColor.label
            inputFieldHasText = true
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if inputField.text.isEmpty {
            setTextField()
        }
    }
    
    func setTextField(to text: String) {
        if text.isEmpty {
            setTextField()
        }
        else {
            inputField.text = text
            inputField.textColor = UIColor.label
            inputFieldHasText = true
        }
    }
    
    func setTextField() {
        inputField.text = placeholderText
        inputField.textColor = UIColor.placeholderText
        inputFieldHasText = false
    }
}
