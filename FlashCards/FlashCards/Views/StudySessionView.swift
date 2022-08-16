//
//  File.swift
//  FlashCards
//
//  Created by Work on 8/13/22.
//

import UIKit


class StudySessionView: UIView {
    init () {
        // Set up subviews
        let layout = EZLayout(spacing: 16)
        
        sideLabel = UILabel(frame: .zero)
        sideLabel.translatesAutoresizingMaskIntoConstraints = false
        sideLabel.textAlignment = .center
        
        sideLabel.font = .preferredFont(forTextStyle: .headline)
        layout.addArrangedSubview(sideLabel, spacing: 8)
        
        let tapToFlipLabel = UILabel(frame: .zero)
        tapToFlipLabel.translatesAutoresizingMaskIntoConstraints = false
        tapToFlipLabel.textAlignment = .center
        tapToFlipLabel.font = .preferredFont(forTextStyle: .caption1)
        tapToFlipLabel.textColor = .secondaryLabel
        tapToFlipLabel.text = "(tap to flip)"
        layout.addArrangedSubview(tapToFlipLabel)
        
        layout.addSeparator(spacing: 48)
        
        contentLabel = UILabel(frame: .zero)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.textAlignment = .center
        contentLabel.font = .preferredFont(forTextStyle: .body)
        contentLabel.numberOfLines = 0
        contentLabel.lineBreakMode = .byWordWrapping
        layout.addArrangedSubview(contentLabel, spacing: 48)
                
        // Back Side Button Panel
        let config = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 58))
        let failButtonImage = UIImage(systemName: "x.circle", withConfiguration: config)
        let successButtonImage = UIImage(systemName: "checkmark.circle", withConfiguration: config)
        
        failButton = UIButton(configuration: .plain())
        failButton.translatesAutoresizingMaskIntoConstraints = false
        failButton.setImage(failButtonImage, for: .normal)
        failButton.tintColor = .systemRed
        failButton.isEnabled = false
        
        successButton = UIButton(configuration: .plain())
        successButton.translatesAutoresizingMaskIntoConstraints = false
        successButton.setImage(successButtonImage, for: .normal)
        successButton.tintColor = .systemGreen
        successButton.isEnabled = false
        
        buttonPanel = UIStackView(arrangedSubviews: [failButton, successButton])
        buttonPanel.translatesAutoresizingMaskIntoConstraints = false
        buttonPanel.isLayoutMarginsRelativeArrangement = true
        buttonPanel.axis = .horizontal
        buttonPanel.distribution = .fillEqually
        buttonPanel.alignment = .center
        buttonPanel.alpha = 0.0
        
        currentSide = .front
        
        super.init(frame: .zero)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
        
        failButton.addAction(UIAction(handler: { _ in self.handleButtonPress(for: .failure) }), for: .touchUpInside)
        successButton.addAction(UIAction(handler: { _ in self.handleButtonPress(for: .success) }), for: .touchUpInside)
        
        // View Hierarchy
        addSubview(layout)
        addSubview(buttonPanel)
        addConstraints([
            layout.topAnchor.constraint(equalTo: topAnchor),
            layout.bottomAnchor.constraint(equalTo: buttonPanel.topAnchor),
            layout.leadingAnchor.constraint(equalTo: leadingAnchor),
            layout.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            buttonPanel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2),
            buttonPanel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            buttonPanel.leadingAnchor.constraint(equalTo: leadingAnchor),
            buttonPanel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCard(_ card: Card) {
        self.card = card
        showSide(.front)
    }
    
    private func showSide(_ side: Side) {
        currentSide = side
        
        let buttonsEnabled: Bool
        let labelText: String
        let content: String
        let alpha: Double
        
        switch side {
        case .front:
            buttonsEnabled = false
            labelText = "Front"
            content = card.frontContent
            alpha = 0.0
        case .back:
            buttonsEnabled = true
            labelText = "Back"
            content = card.backContent
            alpha = 1.0
        }
        
        successButton.isEnabled = buttonsEnabled
        failButton.isEnabled = buttonsEnabled
        self.sideLabel.text = labelText
        self.contentLabel.text = content
        
        UIView.animate(withDuration: TimeInterval(0.1), animations: { self.buttonPanel.alpha = alpha })
    }
    
    private func flip() {
        switch currentSide {
        case .front:
            showSide(.back)
        case .back:
            showSide(.front)
        }
    }
    
    // MARK: Actions
    @objc private func handleTap(_ sender: UIGestureRecognizer) {
        flip()
    }
    
    
    private func handleButtonPress(for result: StudyResult) {
        UIView.animate(withDuration: TimeInterval(0.1), animations: { self.alpha = 0.0 }) { _ in
            let finished = self.delegate.didStudyCard(self.card, with: result)
            
            if finished {
                return
            }
            else {
                UIView.animate(withDuration: TimeInterval(0.1), animations: { self.alpha = 1.0 })
            }
        }
    }
    
    
    // MARK: Properties
    var delegate: StudySessionViewController!
    
    private var sideLabel: UILabel
    private var contentLabel: UILabel
    private var buttonPanel: UIStackView
    private var failButton: UIButton
    private var successButton: UIButton
    
    private var card: Card!
    private var currentSide: Side
    
    enum Side {
        case front
        case back
    }
}

