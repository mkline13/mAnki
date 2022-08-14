//
//  InfoViewer.swift
//  FlashCards
//
//  Created by Work on 8/13/22.
//

import UIKit


class InfoViewer: UIView {
    init (title: String, spacing s: CGFloat = 8.0) {
        spacing = s
        
        let titleLabel = UILabel(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .preferredFont(forTextStyle: .title1).withSize(14)
        titleLabel.textColor = .secondaryLabel
        titleLabel.text = title
        
        previousItem = titleLabel
        
        super.init(frame: .zero)
        addSubview(titleLabel)
        addConstraints([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        finalConstraint = titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        addConstraint(finalConstraint)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addLine(name: String, content: String, contentColor: UIColor = .label) {
        removeConstraint(finalConstraint)
        
        let line = UIView(frame: .zero)
        line.translatesAutoresizingMaskIntoConstraints = false
        
        let nameLabel = UILabel(frame: .zero)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = .secondaryLabel
        nameLabel.font = .preferredFont(forTextStyle: .caption1)
        nameLabel.text = name
        
        let contentLabel = UILabel(frame: .zero)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.font = .preferredFont(forTextStyle: .caption1)
        contentLabel.text = content
        contentLabel.textColor = contentColor
        
        line.addSubview(nameLabel)
        line.addSubview(contentLabel)
        line.addConstraints([
            nameLabel.topAnchor.constraint(equalTo: line.topAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: line.bottomAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: line.leadingAnchor, constant: 16.0),
            nameLabel.widthAnchor.constraint(equalTo: line.widthAnchor, multiplier: 0.3),
            
            contentLabel.topAnchor.constraint(equalTo: line.topAnchor),
            contentLabel.bottomAnchor.constraint(equalTo: line.bottomAnchor),
            contentLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 8.0),
            contentLabel.trailingAnchor.constraint(equalTo: line.trailingAnchor)
        ])
        
        addSubview(line)
        addConstraints([
            line.topAnchor.constraint(equalTo: previousItem.bottomAnchor, constant: spacing),
            line.leadingAnchor.constraint(equalTo: leadingAnchor),
            line.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])

        finalConstraint = line.bottomAnchor.constraint(equalTo: bottomAnchor)
        addConstraint(finalConstraint)
        
        previousItem = line
    }
    
    private let spacing: CGFloat
    private var previousItem: UIView
    private var finalConstraint: NSLayoutConstraint!
}
