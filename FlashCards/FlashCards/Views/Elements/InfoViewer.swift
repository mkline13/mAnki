//
//  InfoViewer.swift
//  FlashCards
//
//  Created by Work on 8/13/22.
//

import UIKit


class InfoViewer: UIView {
    init (title: String, spacing s: CGFloat = 8.0, style: Style = Style()) {
        spacing = s
        defaultStyle = style
        
        let titleLabel = UILabel(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = defaultStyle.titleFont
        titleLabel.textColor = defaultStyle.titleColor
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
    
    // MARK: - InfoViewer
    func addLine(name: String, contentColor: UIColor? = nil, dataProvider: DataLabel.DataProvider? = nil) {
        removeConstraint(finalConstraint)
        
        // Set up line
        let line = Line(dataProvider: dataProvider)
        line.translatesAutoresizingMaskIntoConstraints = false
        lines.append(line)
        
        line.nameLabel.font = defaultStyle.nameFont
        line.nameLabel.textColor = defaultStyle.nameColor
        line.nameLabel.text = name
        
        line.contentLabel.font = defaultStyle.contentFont
        line.contentLabel.textColor = contentColor ?? defaultStyle.contentColor
        
        // View hierarchy
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
    
    func update() {
        for line in lines {
            line.contentLabel.update()
        }
    }
    
    
    // MARK: - Properties
    private let spacing: CGFloat
    private let defaultStyle: Style
    
    private var previousItem: UIView
    private var finalConstraint: NSLayoutConstraint!
    private var lines: [Line] = []
    
    
    // MARK: - Types
    struct Style {
        var titleFont: UIFont = .preferredFont(forTextStyle: .title1).withSize(14)
        var nameFont: UIFont = .preferredFont(forTextStyle: .caption1)
        var contentFont: UIFont = .preferredFont(forTextStyle: .caption1)
        
        var titleColor: UIColor = .secondaryLabel
        var nameColor: UIColor = .secondaryLabel
        var contentColor: UIColor = .label
    }
    
    private class Line: UIView {
        init (dataProvider: DataLabel.DataProvider? = nil) {
            nameLabel = UILabel(frame: .zero)
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            
            contentLabel = DataLabel(dataProvider: dataProvider)
            contentLabel.translatesAutoresizingMaskIntoConstraints = false
            
            super.init(frame: .zero)
            
            addSubview(nameLabel)
            addSubview(contentLabel)
            addConstraints([
                nameLabel.topAnchor.constraint(equalTo: topAnchor),
                nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
                nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
                nameLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3),
                
                contentLabel.topAnchor.constraint(equalTo: topAnchor),
                contentLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
                contentLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 8.0),
                contentLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        let nameLabel: UILabel
        let contentLabel: DataLabel
    }
}
