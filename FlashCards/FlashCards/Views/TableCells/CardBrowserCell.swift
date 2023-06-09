//
//  CardBrowserCell.swift
//  FlashCards
//
//  Created by Work on 8/7/22.
//

import UIKit


class CardBrowserCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        accessoryType = .disclosureIndicator
        
        label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        
        label.font = .preferredFont(forTextStyle: .body)
        
        contentView.addSubview(label)
        contentView.addConstraints([
            label.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for card: Card) {
        updateLabel(card.frontContent, card.backContent)
    }
    
    func updateLabel(_ front: String, _ back: String) {
        label.text = "'\(front)'   |   '\(back)'"
    }
    
    // MARK: Properties
    static let reuseIdentifier = "CardBrowserCell"
    
    private var label: UILabel!
}
