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
        let style = InfoViewer.Style(titleFont: .preferredFont(forTextStyle: .headline),
                                     nameFont: .preferredFont(forTextStyle: .body),
                                     contentFont: .preferredFont(forTextStyle: .headline),
                                     titleColor: .label,
                                     nameColor: .label,
                                     contentColor: .label)
        
        infoViewer = InfoViewer(title: "Study Info:", style: style)
        addCardsButton = UIButton(configuration: .bordered())
        goButton = UIButton(configuration: .filled())
        
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
        
        // Nav Bar
        title = "Study"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(editButton(_:)))
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
        infoViewer.addLine(name: "New cards:", contentColor: .systemBlue) { "\(self.getCardsForStudy(in: self.deck, withStatus: .new).count)" }
        infoViewer.addLine(name: "Learning:", contentColor: .systemRed) { "\(self.getCardsForStudy(in: self.deck, withStatus: .learning).count)" }
        infoViewer.addLine(name: "Review:", contentColor: .systemGreen) { "\(self.getCardsForStudy(in: self.deck, withStatus: .review).count)" }
        layout.addArrangedSubview(infoViewer)
        
        layout.addSeparator(spacing: 32)
        
        // Add cards
        addCardsButton.setTitle("Auto-Add Cards", for: .normal)
        addCardsButton.setTitle("No Available Cards to Add", for: .disabled)
        addCardsButton.addAction(UIAction(handler: handleAddCardsButton), for: .touchUpInside)
        layout.addArrangedSubview(addCardsButton)
        
        // Button Panel
        let buttonPanel = UIView()
        buttonPanel.translatesAutoresizingMaskIntoConstraints = false
        buttonPanel.backgroundColor = UIColor.secondarySystemBackground

        let goButtonAction = UIAction(handler: { _ in self.beginStudy(with: self.deck)})
        goButtonAction.title = "Begin"
        goButton.addAction(goButtonAction, for: .touchUpInside)

        goButton.translatesAutoresizingMaskIntoConstraints = false
        goButton.layer.cornerRadius = 8
        goButton.setTitle("Begin Studying", for: .normal)
        goButton.setTitle("No Cards Remaining", for: .disabled)

        buttonPanel.addSubview(goButton)
        buttonPanel.addConstraints([
            goButton.centerXAnchor.constraint(equalTo: buttonPanel.centerXAnchor),
            goButton.centerYAnchor.constraint(equalTo: buttonPanel.centerYAnchor),
            goButton.widthAnchor.constraint(equalTo: buttonPanel.widthAnchor, multiplier: 2.5/3.0),
            goButton.heightAnchor.constraint(equalTo: buttonPanel.heightAnchor, multiplier: 1/2)
        ])
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateView()
    }
    
    private func updateView() {
        titleLabel.text = deck.title
        descriptionTextLabel.text = deck.deckDescription
        
        // Check if study counters need to be reset for the day
        let calendar = Calendar(identifier: .iso8601)
        if let mostRecentStudySession = deck.previousStudySession {
            if !calendar.isDateInToday(mostRecentStudySession) {
                flashCardService.resetStudyCounters(for: deck)
            }
        }

        // Update card information
        let availableCardsInAssociatedPacks = flashCardService.getAvailableCardsFromContentPacks(for: deck)
        
        let newCardsCount = getCardsForStudy(in: deck, withStatus: .new).count
        let learningCardsCount = getCardsForStudy(in: deck, withStatus: .learning).count
        let reviewCardsCount = getCardsForStudy(in: deck, withStatus: .review).count
        
        let newCardsDeficit = deck.newCardsNeeded - newCardsCount
        
        let totalAvailableCards = newCardsCount + learningCardsCount + reviewCardsCount
        
        // Update views
        if totalAvailableCards > 0 {
            goButton.isEnabled = true
        }
        else {
            goButton.isEnabled = false
        }
        
        if newCardsDeficit > 0 && availableCardsInAssociatedPacks.count > 0 {
            addCardsButton.isEnabled = true
        }
        else {
            addCardsButton.isEnabled = false
        }
        
        infoViewer.update()
    }
    
    // MARK: Actions
    @objc private func editButton(_ sender: UIBarButtonItem) {
        let vc = DeckSettingsViewController(for: deck, flashCardService: flashCardService)
        show(vc, sender: self)
    }
    
    private func beginStudy(with deck: Deck) {
        var cards: [Card] = getCardsForStudy(in: deck, withStatus: .new)
        cards += getCardsForStudy(in: deck, withStatus: .learning)
        cards += getCardsForStudy(in: deck, withStatus: .review)
        
        // collect all study cards in one place
        guard cards.count > 0 else {
            return
        }
        
        flashCardService.performUpdate {
            self.deck.previousStudySession = Date.now
        }
        
        let vc = StudySessionViewController(for: deck, cardsToStudy: cards, dependencyContainer: dependencyContainer)
        
        show(vc, sender: self)
    }
    
    private func handleAddCardsButton(_ sender: UIAction) {
        let newCards = getCardsForStudy(in: deck, withStatus: .new)
        let newCardsDeficit = deck.newCardsNeeded - newCards.count
        
        if newCardsDeficit > 0 {
            let availableCardsInAssociatedPacks = flashCardService.getAvailableCardsFromContentPacks(for: deck)
            self.flashCardService.add(randomCards: availableCardsInAssociatedPacks, to: self.deck, quantity: newCardsDeficit)
        }
        
        updateView()
    }
    
    private func getCardsForStudy(in deck: Deck, withStatus status: Card.Status) -> [Card] {
        switch status {
        case .new:
            return flashCardService.getCards(in: deck, withStatus: .new, withLimit: deck.newCardsNeeded)
        case .learning:
            return flashCardService.getCards(in: deck, withStatus: .learning, withLimit: nil)
        case .review:
            return flashCardService.getCards(in: deck, withStatus: .review, withDueDate: Date.now, withLimit: deck.reviewCardsNeeded)
        }
    }
    
    // MARK: Properties
    private var dependencyContainer: DependencyContainer
    private var flashCardService: FlashCardService
    private var srsService: SRSService
    
    private let deck: Deck
    
    private let titleLabel: UILabel
    private let descriptionTextLabel: UILabel
    private let infoViewer: InfoViewer
    private let addCardsButton: UIButton
    private let goButton: UIButton
}
