//
//  StepperField.swift
//  FlashCards
//
//  Created by Work on 8/13/22.
//

import UIKit


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
