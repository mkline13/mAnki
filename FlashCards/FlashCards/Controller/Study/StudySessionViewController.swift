//
//  StudySessionViewController.swift
//  FlashCards
//
//  Created by Work on 8/8/22.
//

import UIKit


class StudySessionViewController: UIViewController {
    init (for deck: Deck, dependencyContainer dc: DependencyContainer) {
        // Initialize dependencies
        dependencyContainer = dc
        flashCardService = dependencyContainer.flashCardService
        srsService = dependencyContainer.srsService
        
        studySessionView = StudySessionView()
        
        cardsToStudy += flashCardService.getCards(in: deck, with: .new, limit: deck.newCardsPerDay)
        cardsToStudy += flashCardService.getCards(in: deck, with: .learning, limit: nil)
        cardsToStudy += flashCardService.getCards(in: deck, with: .new, limit: deck.newCardsPerDay)
        
        super.init(nibName: nil, bundle: nil)
        
        studySessionView.delegate = self
        
        let studySessionNavAppearance = UINavigationBarAppearance()
        studySessionNavAppearance.configureWithTransparentBackground()
        
        navigationItem.standardAppearance = studySessionNavAppearance
        navigationItem.scrollEdgeAppearance = studySessionNavAppearance
        navigationItem.compactAppearance = studySessionNavAppearance
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
        let cardStatus = srsService.computeNewStatus(for: card, studyResult: result)
        
        flashCardService.updateCard(card, interval: interval, dueDate: dueDate, status: cardStatus)
        
        if cardStatus == .learning {
            discardPile.append(card)
        }
        
        if previousStatus == .learning && cardStatus == .review{
            
        }
        
        let finished = studyNextCard() // Return true when finished
        return finished
    }
    
    
    // MARK: Properties
    private let dependencyContainer: DependencyContainer
    private let flashCardService: FlashCardService
    private let srsService: SRSService
    
    private let studySessionView: StudySessionView
    
    private var cardsToStudy: [Card] = []
    private var discardPile: [Card] = []
    
    enum StudySessionError: Error {
        case deckIsEmpty
    }
}
