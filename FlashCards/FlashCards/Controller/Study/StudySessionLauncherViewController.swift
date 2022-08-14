//
//  StudySessionSetupViewController.swift
//  FlashCards
//
//  Created by Work on 8/7/22.
//

import UIKit


class StudySessionLauncherViewController: UIViewController {
    init (for studyDeck: Deck, dependencyContainer dc: DependencyContainer) {
        dependencyContainer = dc
        flashCardService = dependencyContainer.flashCardService
        srsService = dependencyContainer.srsService
        deck = studyDeck
        
        titleLabel = UILabel(frame: .zero)
        descriptionTextLabel = UILabel(frame: .zero)
        goButton = UIButton(type: .custom)
        
        
        let style = InfoViewer.Style(titleFont: .preferredFont(forTextStyle: .headline),
                                     nameFont: .preferredFont(forTextStyle: .body),
                                     contentFont: .preferredFont(forTextStyle: .headline),
                                     titleColor: .label,
                                     nameColor: .label,
                                     contentColor: .label)
        
        infoViewer = InfoViewer(title: "Study Info:", style: style)
        
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View
    override func loadView() {
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
        infoViewer.addLine(name: "New cards:", contentColor: .systemBlue) { "\(self.numNewCards)" }
        infoViewer.addLine(name: "Learning:", contentColor: .systemRed) { "\(self.numLearningCards)" }
        infoViewer.addLine(name: "Review:", contentColor: .systemGreen) { "\(self.numReviewCards)" }
        layout.addArrangedSubview(infoViewer)
        
        
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
        
        // Nav Bar
        title = "Study"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(editButton(_:)))
    }
    
    private func createButtonPanel() -> UIView {
        let buttonPanel = UIView()
        buttonPanel.translatesAutoresizingMaskIntoConstraints = false
        buttonPanel.backgroundColor = UIColor.secondarySystemBackground

        let goButtonAction = UIAction(handler: { _ in self.beginStudy(with: self.deck)})
        goButtonAction.title = "Begin"
        goButton.addAction(goButtonAction, for: .touchUpInside)

        goButton.translatesAutoresizingMaskIntoConstraints = false
        goButton.backgroundColor = UIColor.systemBlue
        goButton.layer.cornerRadius = 8
        goButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title2)
        goButton.setTitle("Begin Studying", for: .normal)
        goButton.setTitle("No Cards Remaining", for: .disabled)

        buttonPanel.addSubview(goButton)
        buttonPanel.addConstraints([
            goButton.centerXAnchor.constraint(equalTo: buttonPanel.centerXAnchor),
            goButton.centerYAnchor.constraint(equalTo: buttonPanel.centerYAnchor),
            goButton.widthAnchor.constraint(equalTo: buttonPanel.widthAnchor, multiplier: 2.5/3.0),
            goButton.heightAnchor.constraint(equalTo: buttonPanel.heightAnchor, multiplier: 1/2)
        ])
        
        return buttonPanel
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleLabel.text = deck.title
        descriptionTextLabel.text = deck.deckDescription
        
        let totalNewCards = flashCardService.countCards(in: deck, with: .new)
        let totalReviewCards = flashCardService.countCards(in: deck, with: .review)
        
        numNewCards = min(Int(deck.newCardsPerDay - deck.newCardsStudiedRecently), totalNewCards)
        numLearningCards = flashCardService.countCards(in: deck, with: .learning)
        numReviewCards = min(Int(deck.reviewCardsPerDay - deck.reviewCardsStudiedRecently), totalReviewCards)
        
        infoViewer.update()
        
        updateGoButton()
    }
    
    private func updateGoButton() {
        if totalAvailableCards > 0 {
            goButton.isEnabled = true
            goButton.backgroundColor = UIColor.systemBlue
        }
        else {
            goButton.isEnabled = false
            goButton.backgroundColor = UIColor.systemGray
        }
    }
    
    // MARK: Actions
    @objc private func editButton(_ sender: UIBarButtonItem) {
        let vc = DeckSettingsViewController(for: deck, flashCardService: flashCardService)
        show(vc, sender: self)
    }
    
    private func beginStudy(with deck: Deck) {
        // collect all study cards in one place
        guard totalAvailableCards > 0 else {
            return
        }
        let vc = StudySessionViewController(for: deck, dependencyContainer: dependencyContainer)
        
        show(vc, sender: self)
    }
    
    
    // MARK: Properties
    private var dependencyContainer: DependencyContainer
    private var flashCardService: FlashCardService
    private var srsService: SRSService
    
    private let deck: Deck
    
    private let titleLabel: UILabel
    private let descriptionTextLabel: UILabel
    private let goButton: UIButton
    private let infoViewer: InfoViewer
    
    private var numNewCards: Int = 0
    private var numLearningCards: Int = 0
    private var numReviewCards: Int = 0
    
    private var totalAvailableCards: Int {
        numNewCards + numLearningCards + numReviewCards
    }
}
