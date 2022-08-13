//
//  StudySessionViewController.swift
//  FlashCards
//
//  Created by Work on 8/8/22.
//

import UIKit


class StudySessionViewController: UIViewController {
    init (cards: [Card], dependencyContainer dc: DependencyContainer) throws {
        // Check if the initializer was provided cards
        // throw if not
        guard !cards.isEmpty else {
            throw StudySessionError.deckIsEmpty
        }
        cardsToStudy = cards
        
        // Initialize dependencies
        dependencyContainer = dc
        flashCardService = dependencyContainer.flashCardService
        srsService = dependencyContainer.srsService
        
        studySessionView = StudySessionView()
        
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
        
        view.addSubview(studySessionView)
        view.addConstraints([
            studySessionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            studySessionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            studySessionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            studySessionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        studyNextCard()
    }
    
    // MARK: Studying
    private func studyNextCard() {
        // Add failed cards to queue if out of cards to study
        if cardsToStudy.count == 0 && failedCards.count > 0 {
            cardsToStudy = failedCards.shuffled()
            failedCards = []
        }
        
        guard let card = cardsToStudy.popLast() else {
            return didFinishStudying()
        }
        
        // REMOVE: Print study records
        if let suffixIndex = #file.lastIndex(of: "/") {
            let filename = #file.suffix(from: suffixIndex)
            if let deck = card.deck {
                flashCardService.printStudyRecords(for: deck, withMessage: "file: \(filename)   line:\(#line)")
            }
        }
                
        studySessionView.setCard(card)
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
    func didStudyCard(_ card: Card, with result: StudyResult) {
        let record = flashCardService.createStudyRecord(for: card, studyStatus: result, afterInterval: card.srsInterval)!
        let interval = srsService.calculateInterval(previousInterval: card.srsInterval, studyStatus: result)
        let dueDate = srsService.calculateDueDate(interval: interval, studyDate: record.timestamp, studyStatus: result)
        
        // Mark the card as review if studied successfully for the first time
        let cardStatus: Card.Status?
        switch result {
        case .failure:
            failedCards.append(card)
            cardStatus = nil
        case .success:
            cardStatus = .review
        default:
            fatalError("Status not implemented")
        }
        
        flashCardService.updateCard(card, interval: interval, dueDate: dueDate, status: cardStatus)
        
        studyNextCard()
    }
    
    
    // MARK: Properties
    private let dependencyContainer: DependencyContainer
    private let flashCardService: FlashCardService
    private let srsService: SRSService
    
    private let studySessionView: StudySessionView
    
    private var cardsToStudy: [Card] = []
    private var failedCards: [Card] = []
    
    enum StudySessionError: Error {
        case deckIsEmpty
    }
}
