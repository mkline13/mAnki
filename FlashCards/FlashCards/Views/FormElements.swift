//
//  FormElements.swift
//  FlashCards
//
//  Created by Work on 8/10/22.
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


class TextFieldWithLabel: UIView {
    init (labelText: String, initial: String, onUpdate: @escaping UpdateHandler) {
        updateHandler = onUpdate
        
        super.init(frame: .zero)
                
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.text = labelText
        label.textColor = .systemGray
        
        textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .systemFont(ofSize: 14)
        textField.text = initial
        textField.addAction(UIAction(handler: handleUpdateAction), for: .editingChanged)
        
        self.addSubview(label)
        self.addSubview(textField)
        self.addConstraints([
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            label.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25),
            
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


class MultilineTextFieldWithLabel: UIView, UITextViewDelegate {
    init (labelText: String, initial: String, onUpdate: @escaping UpdateHandler) {
        updateHandler = onUpdate
        
        super.init(frame: .zero)
                
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.text = labelText
        label.textColor = .systemGray
        
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = .systemGray
        
        textView = UITextView(frame: .zero)
        textView.delegate = self
        textView.isScrollEnabled = false
        textView.isEditable = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .systemFont(ofSize: 14)
        textView.text = initial
        textView.backgroundColor = .clear
        
        self.addSubview(label)
        self.addSubview(line)
        self.addSubview(textView)
        self.addConstraints([
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            textView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            textView.leadingAnchor.constraint(equalTo: line.leadingAnchor, constant: 8),
            textView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            line.topAnchor.constraint(equalTo: textView.topAnchor, constant: 6),
            line.bottomAnchor.constraint(equalTo: textView.bottomAnchor, constant: -6),
            line.leadingAnchor.constraint(equalTo: label.leadingAnchor, constant: 8),
            line.widthAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        updateHandler(textView.text ?? "")
    }
    
    // MARK: Properties
    var textView: UITextView!
    
    private var updateHandler: UpdateHandler
    typealias UpdateHandler = (String) -> Void
}

class ListView: UIView {
    init (labelText: String, button: UIButton) {
        super.init(frame: .zero)
                
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.text = labelText
        label.textColor = .systemGray
        label.setContentHuggingPriority(UILayoutPriority(1), for: .horizontal)
        
        itemsLabel = UILabel(frame: .zero)
        itemsLabel.translatesAutoresizingMaskIntoConstraints = false
        itemsLabel.font = .systemFont(ofSize: 12)
        itemsLabel.numberOfLines = 0
        itemsLabel.lineBreakMode = .byWordWrapping
        itemsLabel.setContentHuggingPriority(UILayoutPriority(1), for: .horizontal)
                
        button.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .horizontal)
                
        self.addSubview(label)
        self.addSubview(itemsLabel)
        self.addSubview(button)
        self.addConstraints([
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            label.trailingAnchor.constraint(lessThanOrEqualTo: button.leadingAnchor),
            
            itemsLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            itemsLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            itemsLabel.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -8),
            itemsLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            button.topAnchor.constraint(equalTo: label.topAnchor),
            button.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            button.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor)
        ])
    }
    
    func update(with items: [String]) {
        itemsLabel.text = items.joined(separator: ", ")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Properties
    var itemsLabel: UILabel!
}

class StepperField: UIView {
    init (labelText: String, initial: Int64, onUpdate: @escaping UpdateHandler) {
        updateHandler = onUpdate
        
        super.init(frame: .zero)
        
        let nameLabel = UILabel(frame: .zero)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .systemFont(ofSize: 12)
        nameLabel.text = labelText
        nameLabel.textColor = .systemGray
        
        valueLabel = UILabel(frame: .zero)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.font = .systemFont(ofSize: 14)
        valueLabel.text = "\(initial)"
        
        stepper = UIStepper(frame: .zero)
        stepper.translatesAutoresizingMaskIntoConstraints = false
        
        stepper.addAction(UIAction(handler: handleUpdateAction), for: .valueChanged)
        stepper.value = Double(initial)
        
        self.addSubview(nameLabel)
        self.addSubview(valueLabel)
        self.addSubview(stepper)
        self.addConstraints([
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: valueLabel.leadingAnchor),
            
            valueLabel.topAnchor.constraint(equalTo: self.topAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: stepper.leadingAnchor, constant: -16),
            
            stepper.topAnchor.constraint(equalTo: self.topAnchor),
            stepper.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stepper.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func handleUpdateAction(_ action: UIAction) {
        valueLabel.text = "\(Int(self.stepper.value))"
        updateHandler(Int64(self.stepper.value))
    }
    
    private var valueLabel: UILabel!
    private var stepper: UIStepper!
    private var updateHandler: UpdateHandler
    
    typealias UpdateHandler = (Int64) -> Void
}


class Spacer: UIView {
    init () {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class Separator: UIView {
    init () {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundColor = .systemGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 0.5)
    }
}
