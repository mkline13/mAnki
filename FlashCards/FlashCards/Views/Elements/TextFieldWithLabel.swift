//
//  TextFieldWithLabel.swift
//  FlashCards
//
//  Created by Work on 8/13/22.
//

import UIKit


class TextFieldWithLabel: UIView {
    init (labelText: String, initial: String, onUpdate: @escaping UpdateHandler) {
        updateHandler = onUpdate
        
        super.init(frame: .zero)
                
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .caption1)
        label.text = labelText
        label.textColor = .secondaryLabel
        
        textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .preferredFont(forTextStyle: .body)
        textField.text = initial
        textField.addAction(UIAction(handler: handleUpdateAction), for: .editingChanged)
        
        self.addSubview(label)
        self.addSubview(textField)
        self.addConstraints([
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            label.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.15),
            
            textField.topAnchor.constraint(equalTo: self.topAnchor),
            textField.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 8),
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    private func handleUpdateAction(_ action: UIAction) {
        updateHandler(self.textField.text ?? "")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Properties
    var textField: UITextField!
    
    private var updateHandler: UpdateHandler
    typealias UpdateHandler = (String) -> Void
}
