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
        
        super.init(nibName: nil, bundle: nil)
        
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
//        title = "Study"
        
        view = UIView(frame: .zero)
        view.backgroundColor = UIColor.systemBackground
        
        let layout = EZLayout(spacing: 16)
        
        layout.addSpacer()
        
        titleLabel = UILabel(frame: .zero)
        titleLabel.textAlignment = .center
        titleLabel.font = ViewConstants.titleFont
        layout.addArrangedSubview(titleLabel)
        
        let descriptionLabel = UILabel(frame: .zero)
        descriptionLabel.font = ViewConstants.regularFont
        descriptionLabel.textColor = ViewConstants.labelColor
        descriptionLabel.text = "Description:"
        layout.addArrangedSubview(descriptionLabel, spacing: 8)
        
        descriptionTextLabel = UILabel(frame: .zero)
        descriptionTextLabel.font = ViewConstants.regularFont
        layout.addArrangedSubview(descriptionTextLabel)
        
        layout.addSeparator()
        
        // Go button
        let buttonPanel = UIView()
        buttonPanel.translatesAutoresizingMaskIntoConstraints = false
        buttonPanel.backgroundColor = UIColor.secondarySystemBackground

        let goButtonAction = UIAction(handler: { _ in self.beginStudy(with: self.deck)})
        goButtonAction.title = "Begin"

        goButton = UIButton.init(type: .custom, primaryAction: goButtonAction)
        goButton.translatesAutoresizingMaskIntoConstraints = false
        goButton.backgroundColor = UIColor.systemBlue
        goButton.layer.cornerRadius = 8
        goButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(editButton(_:)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadStudyCards()
        
        titleLabel.text = deck.title
        descriptionTextLabel.text = deck.deckDescription
        
        if totalStudyCards > 0 {
            goButton.isEnabled = true
            goButton.backgroundColor = UIColor.systemBlue
        }
        else {
            goButton.isEnabled = false
            goButton.backgroundColor = UIColor.systemGray
        }
    }
    
    // MARK: Table
    enum Row: CaseIterable {
        case titleLabel
        case descriptionLabel
        case newCardsRemaining
        case reviewCardsRemaining
    }
    
    // MARK: Actions
    @objc private func editButton(_ sender: UIBarButtonItem) {
        let vc = DeckSettingsViewController(for: deck, flashCardService: flashCardService)
        show(vc, sender: self)
    }
    
    private func beginStudy(with deck: Deck) {
        // add all new cards from packs to the deck
        flashCardService.add(cards: newCardsFromPacks, to: deck)
        
        // collect all study cards in one place
        let cards = newCardsFromDeck + newCardsFromPacks + reviewCards
        
        guard let vc = try? StudySessionViewController(cards: cards, dependencyContainer: dependencyContainer) else {
            fatalError("Cannot study: deck is empty")
        }
        
        show(vc, sender: self)
    }
    
    private func loadStudyCards() {
        newCardsFromDeck = flashCardService.getNewCards(in: deck, limit: deck.newCardsPerDay)
        newCardsFromPacks = flashCardService.drawNewCards(for: deck, limit: deck.newCardsPerDay - Int64(newCardsFromDeck.count))
        reviewCards = flashCardService.getReviewCards(in: deck, limit: deck.reviewCardsPerDay)
        
        print("\nBeginning study session with deck: \(deck.title)")
        print("New Cards from Deck:")
        for c in newCardsFromDeck {
            print("  - \(c.frontContent)")
        }
        print("New Cards from ContentPacks:")
        for c in newCardsFromPacks {
            print("  - \(c.frontContent)")
        }
        print("Review Cards:")
        for c in reviewCards {
            print("  - \(c.frontContent)")
        }
        print("")
    }
    
    // MARK: Properties
    private var dependencyContainer: DependencyContainer
    private var flashCardService: FlashCardService
    private var srsService: SRSService
    
    private var deck: Deck
    
    private var titleLabel: UILabel!
    private var descriptionTextLabel: UILabel!
    private var goButton: UIButton!
    
    private var newCardsFromDeck: [Card] = []
    private var newCardsFromPacks: [Card] = []
    private var reviewCards: [Card] = []
    
    private var totalStudyCards: Int {
        return newCardsFromDeck.count + newCardsFromPacks.count + reviewCards.count
    }
}
