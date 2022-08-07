//
//  StepperCell.swift
//  FlashCards
//
//  Created by Work on 8/5/22.
//

import UIKit


class StepperCell: UITableViewCell, FormField {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                
        titleLabel = UILabel(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        
        numberLabel = UILabel(frame: .zero)
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        numberLabel.font = UIFont.systemFont(ofSize: 14)
        
        let stepperAction = UIAction(handler: { _ in
            self.delegate.formField(self, key: self.key, value: self.value)
            self.updateLabel()
        })
        stepper = UIStepper(frame: .zero, primaryAction: stepperAction)
        stepper.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(numberLabel)
        contentView.addSubview(stepper)
        contentView.addConstraints([
            titleLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: numberLabel.leadingAnchor, constant: 8),
            
            numberLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            numberLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            numberLabel.trailingAnchor.constraint(equalTo: stepper.leadingAnchor, constant: -16),
            
            stepper.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            stepper.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            stepper.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
        ])
        
        // Make cell unselectable
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: FormField
    func configure(label text: String?, key: Int, value: Any, delegate: FormFieldDelegate) {
        guard let value = value as? Int64 else {
            fatalError("Expected Int as value")
        }
        
        self.key = key
        self.delegate = delegate
        
        self.titleLabel.text = text
        self.value = value
        
        self.updateLabel()
    }
    
    // MARK: View
    func updateLabel () {
        self.numberLabel.text = "\(Int(stepper.value))"
    }
    
    // MARK: Properties
    static let reuseIdentifier: String = "IncDecCell"
    private var key: Int!
    private var delegate: FormFieldDelegate!
    
    private var titleLabel: UILabel!
    private var numberLabel: UILabel!
    private var label: UILabel!
    private var stepper: UIStepper!
    
    private var value: Int64 {
        get {
            Int64(self.stepper.value)
        }
        set (newValue) {
            self.stepper.value = Double(newValue)
        }
    }
}
