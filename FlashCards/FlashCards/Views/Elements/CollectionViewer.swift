//
//  CollectionViewer.swift
//  FlashCards
//
//  Created by Work on 8/13/22.
//

import UIKit


class CollectionViewer: UIView {
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
