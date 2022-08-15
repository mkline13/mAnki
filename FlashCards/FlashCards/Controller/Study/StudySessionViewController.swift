//
//  StudySessionViewController.swift
//  FlashCards
//
//  Created by Work on 8/8/22.
//

import UIKit


class StudySessionViewController: UIViewController {
    init (for studyDeck: Deck, dependencyContainer dc: DependencyContainer) {
        // Initialize dependencies
        dependencyContainer = dc
        flashCardService = dependencyContainer.flashCardService
        srsService = dependencyContainer.srsService
        
        deck = studyDeck
        
        studySessionView = StudySessionView()
        
        cardsToStudy += flashCardService.getCards(in: deck, with: .new, limit: deck.newCardsPerDay - deck.newCardsStudiedRecently)
        cardsToStudy += flashCardService.getCards(in: deck, with: .learning, limit: nil)
        cardsToStudy += flashCardService.getCards(in: deck, with: .review, limit: deck.reviewCardsPerDay - deck.reviewCardsStudiedRecently)
        
        super.init(nibName: nil, bundle: nil)
        
        studySessionView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View
    override func loadView() {
        view = UIView(frame: .zero)
        view.backgroundColor = .systemBackground
        
        studySessionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubviewAndFit(studySessionView)
        
        let studySessionNavAppearance = UINavigationBarAppearance()
        studySessionNavAppearance.configureWithTransparentBackground()
        
        navigationItem.standardAppearance = studySessionNavAppearance
        navigationItem.scrollEdgeAppearance = studySessionNavAppearance
        navigationItem.compactAppearance = studySessionNavAppearance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let _ = studyNextCard()
    }
    
    // MARK: Studying
    private func studyNextCard() -> Bool {
        // Add failed cards to queue if out of cards to study
        if cardsToStudy.count == 0 && discardPile.count > 0 {
            cardsToStudy = discardPile.shuffled()
            discardPile = []
        }
        
        guard let card = cardsToStudy.popLast() else {
            didFinishStudying()
            return true  // Return true when finished studying
        }
        
        // REMOVE: Print study records
        if let suffixIndex = #file.lastIndex(of: "/") {
            let filename = #file.suffix(from: suffixIndex)
            if let deck = card.deck {
                flashCardService.printStudyRecords(for: deck, withMessage: "file: \(filename)   line:\(#line)")
            }
        }
                
        studySessionView.setCard(card)
        return false
    }
    
    // MARK: Actions
    private func didFinishStudying() {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        }
        else {
            dismiss(animated: true)
        }
    }
    
    
    // MARK: - SRS
    func didStudyCard(_ card: Card, with result: StudyResult) -> Bool {
        let record = flashCardService.createStudyRecord(for: card, studyStatus: result, afterInterval: card.srsInterval)!
        let interval = srsService.calculateInterval(previousInterval: card.srsInterval, studyStatus: result)
        let dueDate = srsService.calculateDueDate(interval: interval, studyDate: record.timestamp, studyStatus: result)
        
        let previousStatus = card.status
        let currentStatus = srsService.computeNewStatus(for: card, studyResult: result)
        
        // increment daily study counter
        if previousStatus == .new {
            flashCardService.incrementNewCardsStudiedRecently(for: deck)
        }
        else if previousStatus == .review {
            flashCardService.incrementReviewCardsStudiedRecently(for: deck)
        }
        
        // update card with new study data
        flashCardService.updateCard(card, interval: interval, dueDate: dueDate, status: currentStatus)
        
        // put card in discardPile to be shown later in this session
        if currentStatus == .learning {
            discardPile.append(card)
        }
        
        // Continue
        return studyNextCard() // Return true when finished
    }
    
    
    // MARK: Properties
    private let dependencyContainer: DependencyContainer
    private let flashCardService: FlashCardService
    private let srsService: SRSService
    
    private let deck: Deck
    private let studySessionView: StudySessionView
    
    private var cardsToStudy: [Card] = []
    private var discardPile: [Card] = []
    
    enum StudySessionError: Error {
        case deckIsEmpty
    }
}
