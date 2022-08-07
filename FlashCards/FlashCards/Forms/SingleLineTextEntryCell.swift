//
//  TitleCell.swift
//  FlashCards
//
//  Created by Work on 8/5/22.
//

import UIKit


class SingleLineTextEntryCell: UITableViewCell, FormField {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                
        textField = UITextField()
        
        contentView.addSubview(textField)
        contentView.addConstraints([
            textField.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            textField.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
        ])
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 14)
        
        // TextField actions
        let textEditedAction = UIAction { _ in
            let formattedResult = self.textField.text?.trimmingCharacters(in: .whitespaces) ?? ""
            self.delegate.formField(self, key: self.key, value: formattedResult)
        }
        textField.addAction(textEditedAction, for: .editingChanged)
        
        // Make cell unselectable
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: FormCell
    func configure(label: String?, key: Int, value: Any, delegate: FormFieldDelegate) {
        self.key = key
        self.delegate = delegate
        
        textField.text = value as? String ?? ""
        textField.placeholder = label
    }
    
    // MARK: Properties
    static let reuseIdentifier = "SingleLineTextEntryCell"
    
    private var key: Int!
    private var delegate: FormFieldDelegate!
    
    private var textField: UITextField!
    
    var font: UIFont? {
        get {
            textField.font
        }
        set (newValue) {
            textField.font = newValue
        }
    }
}
