//
//  DeckListCell.swift
//  FlashCards
//
//  Created by Work on 8/13/22.
//

import UIKit


class DeckListCell: UITableViewCell {
    // MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.accessoryType = .disclosureIndicator
        
        label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(label)
        contentView.addConstraints([
            label.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            label.trailingAnchor.constraint(lessThanOrEqualTo: contentView.layoutMarginsGuide.trailingAnchor),
        ])
        
        label.font = .preferredFont(forTextStyle: .body)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View
    func configure(for deck: Deck) {
        label.text = deck.title
        
        accessibilityLabel = deck.title
    }
    
    // MARK: Properties
    static let reuseIdentifier: String = "DeckListTableCell"
    private var label: UILabel!
}
