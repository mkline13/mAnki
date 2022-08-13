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
        
        sideLabel.font = .systemFont(ofSize: 12, weight: .medium)
        layout.addArrangedSubview(sideLabel, spacing: 8)
        
        let tapToFlipLabel = UILabel(frame: .zero)
        tapToFlipLabel.translatesAutoresizingMaskIntoConstraints = false
        tapToFlipLabel.textAlignment = .center
        tapToFlipLabel.font = ViewConstants.smallFont
        tapToFlipLabel.textColor = ViewConstants.labelColor
        tapToFlipLabel.text = "(tap to flip)"
        layout.addArrangedSubview(tapToFlipLabel)
        
        layout.addSeparator(spacing: 48)
        
        contentLabel = UILabel(frame: .zero)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.textAlignment = .center
        contentLabel.font = ViewConstants.regularFont
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
        
        failButton.addAction(UIAction(handler: handleFailButtonPress), for: .touchUpInside)
        successButton.addAction(UIAction(handler: handleSuccessButtonPress), for: .touchUpInside)
        
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
        showFront()
    }
    
    private func showFront() {
        currentSide = .front
        
        successButton.isEnabled = false
        failButton.isEnabled = false
        
        sideLabel.text = "Front"
        UIView.animate(withDuration: TimeInterval(0.08)) {
            self.buttonPanel.alpha = 0.0
        }
        
        contentLabel.text = card.frontContent
    }
    
    private func showBack() {
        currentSide = .back
        
        successButton.isEnabled = true
        failButton.isEnabled = true
        
        sideLabel.text = "Back"
        UIView.animate(withDuration: TimeInterval(0.08)) {
            self.buttonPanel.alpha = 1.0
        }
        
        contentLabel.text = card.backContent
    }
    
    private func flip() {
        switch currentSide {
        case .front:
            showBack()
        case .back:
            showFront()
        }
    }
    
    // MARK: Actions
    @objc private func handleTap(_ sender: UIGestureRecognizer) {
        flip()
    }
    
    private func handleSuccessButtonPress(_ action: UIAction) {
        let fadeOut = {
            self.alpha = 0.0
        }
        
        UIView.animate(withDuration: TimeInterval(0.2), animations: fadeOut) { _ in
            UIView.animate(withDuration: TimeInterval(0.2)) {
                self.delegate.didStudyCard(self.card, with: .success)
                self.alpha = 1.0
            }
        }
    }
    
    private func handleFailButtonPress(_ action: UIAction) {
        delegate.didStudyCard(card, with: .failure)
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

