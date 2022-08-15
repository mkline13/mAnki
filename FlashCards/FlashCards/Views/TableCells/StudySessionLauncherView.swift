//
//  StudySessionLauncherView.swift
//  FlashCards
//
//  Created by Work on 8/15/22.
//

import UIKit


class StudySessionLauncherView: UIView {
    init() {
        view = UIView(frame: .zero)
        view.backgroundColor = UIColor.systemBackground
        
        let layout = EZLayout(spacing: 16)
        
        layout.addSpacer(height: 32)
        
        // Title Label
        titleLabel.textAlignment = .center
        titleLabel.font = .preferredFont(forTextStyle: .largeTitle)
        layout.addArrangedSubview(titleLabel, spacing: 32)
        
        // Description Label
        descriptionTextLabel.font = .preferredFont(forTextStyle: .body)
        layout.addArrangedSubview(descriptionTextLabel)
        
        layout.addSeparator(spacing: 32)
        
        // Info View
        infoViewer.addLine(name: "New cards:", contentColor: .systemBlue) { "\(self.newCardsToStudy)" }
        infoViewer.addLine(name: "Learning:", contentColor: .systemRed) { "\(self.numLearningCards)" }
        infoViewer.addLine(name: "Review:", contentColor: .systemGreen) { "\(self.numReviewCards)" }
        layout.addArrangedSubview(infoViewer)
        
        layout.addSeparator(spacing: 32)
        
        // Add cards
        addCardsButton.setTitle("Auto-Add Cards", for: .normal)
        addCardsButton.setTitle("No Available Cards to Add", for: .disabled)
        addCardsButton.addAction(UIAction(handler: handleAddCardsButton), for: .touchUpInside)
        layout.addArrangedSubview(addCardsButton)
        
        // Button Panel
        let buttonPanel = createButtonPanel()
        
        view.addSubview(layout)
        view.addSubview(buttonPanel)
        view.addConstraints([
            layout.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            layout.bottomAnchor.constraint(equalTo: buttonPanel.topAnchor),
            layout.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            layout.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            buttonPanel.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 1.0/5.0),
            buttonPanel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            buttonPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
