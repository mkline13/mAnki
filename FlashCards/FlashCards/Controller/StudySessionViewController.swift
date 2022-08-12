//
//  StudySessionViewController.swift
//  FlashCards
//
//  Created by Work on 8/8/22.
//

import UIKit


class StudySessionViewController: UIViewController {
    init (cards: [Card], flashCardService: FlashCardService, srsService: SRSService) throws {
        super.init(nibName: nil, bundle: nil)
        self.flashCardService = flashCardService
        self.srsService = srsService
        
        // Decide which cards are ready to study
        // Show those cards
        
        cardsToStudy = cards
        if cardsToStudy.isEmpty {
            throw StudySessionError.deckIsEmpty
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View
    override func loadView() {
        title = "Study"
        
        view = UIView(frame: .zero)
        view.backgroundColor = UIColor.systemBackground
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
        
        sideLabel = UILabel(frame: .zero)
        sideLabel.translatesAutoresizingMaskIntoConstraints = false
        sideLabel.textAlignment = .center
        sideLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        
        contentLabel = UILabel(frame: .zero)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.textAlignment = .center
        contentLabel.numberOfLines = 0
        contentLabel.lineBreakMode = .byWordWrapping
        contentLabel.backgroundColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        
        let tapToFlipLabel = UILabel(frame: .zero)
        tapToFlipLabel.translatesAutoresizingMaskIntoConstraints = false
        tapToFlipLabel.font = tapToFlipLabel.font.withSize(12)
        tapToFlipLabel.textColor = tapToFlipLabel.textColor.withAlphaComponent(0.4)
        tapToFlipLabel.text = "(tap)"
        
        // Back Side Button Panel
        let config = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 58))
        let failButtonImage = UIImage(systemName: "x.circle", withConfiguration: config)
        let successButtonImage = UIImage(systemName: "checkmark.circle", withConfiguration: config)
        
        failButton = UIButton(configuration: .plain(), primaryAction: UIAction(handler: {_ in self.mark(.failure)}))
        failButton.translatesAutoresizingMaskIntoConstraints = false
        failButton.setImage(failButtonImage, for: .normal)
        failButton.tintColor = .systemRed
        
        successButton = UIButton(configuration: .plain(), primaryAction: UIAction(handler: {_ in self.mark(.success)}))
        successButton.translatesAutoresizingMaskIntoConstraints = false
        successButton.setImage(successButtonImage, for: .normal)
        successButton.tintColor = .systemGreen
        
        buttonPanel = UIStackView(arrangedSubviews: [failButton, successButton])
        buttonPanel.translatesAutoresizingMaskIntoConstraints = false
        buttonPanel.isLayoutMarginsRelativeArrangement = true
        buttonPanel.axis = .horizontal
        buttonPanel.distribution = .fillEqually
        buttonPanel.alignment = .center
        
        // View Hierarchy
        view.addSubview(sideLabel)
        view.addSubview(contentLabel)
        view.addSubview(tapToFlipLabel)
        view.addSubview(buttonPanel)
        view.addConstraints([
            sideLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            sideLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            
            contentLabel.topAnchor.constraint(equalTo: sideLabel.bottomAnchor, constant: 32),
            contentLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            tapToFlipLabel.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 32),
            tapToFlipLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tapToFlipLabel.bottomAnchor.constraint(lessThanOrEqualTo: buttonPanel.topAnchor, constant: -2),
            
            buttonPanel.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.2),
            buttonPanel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            buttonPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        studyNextCard()
    }
    
    
    
    private func flipCard() {
        switch currentSide {
        case .front:
            show(.back, of: currentCard)
        case .back:
            show(.front, of: currentCard)
        }
    }
    
    private func show(_ side: CardSide, of card: Card) {
        currentSide = side
        
        switch side {
        case .front:
            successButton.isEnabled = false
            failButton.isEnabled = false
            updateLabels(side: currentSide.string, content: card.frontContent)
            buttonPanel.alpha = 0.0
        case .back:
            successButton.isEnabled = true
            failButton.isEnabled = true
            updateLabels(side: currentSide.string, content: card.backContent)
            buttonPanel.alpha = 1.0
        }
    }
    
    private func updateLabels(side: String, content: String) {
        sideLabel.text = side
        contentLabel.text = content
    }
    
    // MARK: Studying
    private func studyNextCard() {
        if cardsToStudy.count > 0 {
            currentCard = cardsToStudy.popLast()
        }
        else if failedCards.count > 0 {
            cardsToStudy = failedCards.shuffled()
            failedCards = []
            currentCard = cardsToStudy.popLast()
        }
        else {
            return didFinishStudying()
        }
        
        // REMOVE: Print study records
        if let suffixIndex = #file.lastIndex(of: "/") {
            let filename = #file.suffix(from: suffixIndex)
            if let deck = currentCard.deck {
                flashCardService.printStudyRecords(for: deck, withMessage: "file: \(filename)   line:\(#line)")
            }
        }
                
        show(.front, of: currentCard)
    }
    
    // MARK: Actions
    @objc private func handleTap(_ sender: UIGestureRecognizer) {
        flipCard()
    }
    
    private func didFinishStudying() {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        }
        else {
            dismiss(animated: true)
        }
    }
    
    
    // MARK: - SRS
    private func mark(_ status: StudyStatus) {
        let record = flashCardService.createStudyRecord(for: currentCard, studyStatus: status, afterInterval: currentCard.srsInterval)!
        let interval = srsService.calculateInterval(previousInterval: currentCard.srsInterval, studyStatus: status)
        let dueDate = srsService.calculateDueDate(interval: interval, studyDate: record.timestamp, studyStatus: status)
        
        let cardStatus: Card.Status?
        switch status {
        case .failure:
            failedCards.append(currentCard)
            cardStatus = nil
        case .success:
            cardStatus = .review
        default:
            fatalError("Status not implemented")
        }
        
        flashCardService.updateCard(currentCard, interval: interval, dueDate: dueDate, status: cardStatus)
        
        studyNextCard()
    }
    
    
    // MARK: Properties
    private var flashCardService: FlashCardService!
    private var srsService: SRSService!
    
    private var sideLabel: UILabel!
    private var contentLabel: UILabel!
    private var buttonPanel: UIStackView!
    private var failButton: UIButton!
    private var successButton: UIButton!
    
    private var cardsToStudy: [Card] = []
    private var failedCards: [Card] = []
    private var currentCard: Card!
    
    private var currentSide: CardSide = .front
    
    enum CardSide {
        case front
        case back
        
        var string: String {
            switch self {
            case .front:
                return "front"
            case .back:
                return "back"
            }
        }
    }
    
    enum StudySessionError: Error {
        case deckIsEmpty
    }
}
