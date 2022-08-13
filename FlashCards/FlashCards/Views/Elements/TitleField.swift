//
//  TitleField.swift
//  FlashCards
//
//  Created by Work on 8/13/22.
//

import UIKit


class TitleField: UIView {
    init (labelText: String, placeholder: String, initial: String, onUpdate: @escaping UpdateHandler) {
        updateHandler = onUpdate
        
        label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = ViewConstants.smallFont
        label.textColor = ViewConstants.labelColor
        label.text = labelText
        
        textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = ViewConstants.titleFont
        textField.placeholder = placeholder
        textField.text = initial
        
        super.init(frame: .zero)
        
        // Layout
        self.addSubview(label)
        self.addSubview(textField)
        self.addConstraints([
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            textField.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
        
        // Actions
        textField.addAction(UIAction(handler: handleUpdateAction), for: .editingChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func handleUpdateAction(_ action: UIAction) {
        updateHandler(self.textField.text ?? "")
    }
    
    // MARK: Properties
    private var label: UILabel
    private var textField: UITextField
    
    private var updateHandler: UpdateHandler
    typealias UpdateHandler = (String) -> Void
}
