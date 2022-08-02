//
//  TextEntryCell.swift
//  FlashCards
//
//  Created by Work on 8/1/22.
//

import UIKit


class TextEntryCell: UITableViewCell {
    static let cellIdentifier = "TextEntryCell"
    
    // MARK: Properties
    var fieldIdentifier: String!
    @IBOutlet private weak var inputField: UITextField!
    
    // MARK: UI
    func configure(fieldIdentifier identifier: String, placeholderText placeholder: String? = nil) {
        self.selectionStyle = .none
        
        self.fieldIdentifier = identifier
        if let placeholder = placeholder {
            self.inputField.placeholder = placeholder
        }
        else {
            self.inputField.placeholder = identifier
        }
    }
}
