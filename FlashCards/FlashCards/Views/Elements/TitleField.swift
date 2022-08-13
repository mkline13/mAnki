//
//  TitleField.swift
//  FlashCards
//
//  Created by Work on 8/13/22.
//

import UIKit


class TitleField: UIView {
    init (placeholder: String, initial: String, onUpdate: @escaping UpdateHandler) {
        updateHandler = onUpdate
        
        super.init(frame: .zero)
        
        textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .systemFont(ofSize: 24, weight: .bold)
        textField.placeholder = placeholder
        textField.text = initial
        textField.addAction(UIAction(handler: handleUpdateAction), for: .editingChanged)
        
        self.addSubview(textField)
        self.addConstraints([
            textField.topAnchor.constraint(equalTo: self.topAnchor),
            textField.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func handleUpdateAction(_ action: UIAction) {
        updateHandler(self.textField.text ?? "")
    }
    
    var textField: UITextField!
    
    private var updateHandler: UpdateHandler
    typealias UpdateHandler = (String) -> Void
}
