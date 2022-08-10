//
//  StudySessionViewController.swift
//  FlashCards
//
//  Created by Work on 8/8/22.
//

import UIKit


class StudySessionViewController: UIViewController, CardViewControllerDelegate {
    init(for deck: Deck, FlashCardService: FlashCardService) {
        super.init(nibName: nil, bundle: nil)
        self.deck = deck
        
        self.flashCardService = FlashCardService
        
        frontViewController = FrontViewController(with: self)
        backViewController = BackViewController(with: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View
    override func loadView() {
        title = "Study"
        
        view = UIView(frame: .zero)
        view.backgroundColor = UIColor.systemBackground
        
        guard deck.cards.count > 0 else {
            fatalError("Could not load card, no cards in deck")
        }
        
        embedChildViewController(frontViewController)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentCard = deck.cards.anyObject() as! Card?
        
        currentViewController.configure(for: currentCard!)
    }
    
    // MARK: CardViewControllerDelegate
    func flipCard(_ sender: CardViewController) {
        switch currentViewController.side {
        case .front:
            unembedChildViewController(frontViewController)
            embedChildViewController(backViewController)
        case .back:
            unembedChildViewController(backViewController)
            embedChildViewController(frontViewController)
        }
        currentViewController.configure(for: currentCard!)
    }
    
    func set(toSide side: CardSide) {
        switch currentViewController.side {
        case .back:
            unembedChildViewController(frontViewController)
            embedChildViewController(backViewController)
        case .front:
            unembedChildViewController(backViewController)
            embedChildViewController(frontViewController)
        }
        currentViewController.configure(for: currentCard!)
    }
    
    func unembedChildViewController(_ child: CardViewController) {
        child.willMove(toParent: nil)
        child.removeConstraintsFromParent()
        child.view.removeFromSuperview()
        child.removeFromParent()
        currentViewController = nil
    }
    
    func embedChildViewController(_ child: CardViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.addConstraintsToParent()
        child.didMove(toParent: self)
        currentViewController = child
    }
    
    func finishStudyingCard(_ sender: CardViewController, card: Card, status: StudyStatus) {
        print("DONE STUDYING")
    }
    
    // MARK: Properties
    private var flashCardService: FlashCardService!
    private var deck: Deck!
    private var currentCard: Card?
    
    private var frontViewController: CardViewController!
    private var backViewController: CardViewController!
    private var currentViewController: CardViewController!
}

protocol CardViewControllerDelegate {
    func flipCard(_ sender: CardViewController)
    func finishStudyingCard (_ sender: CardViewController, card: Card, status: StudyStatus)
}

enum CardSide {
    case front
    case back
}

class CardViewController: UIViewController {
    init (with delegate: CardViewControllerDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View
    override func loadView() {
        // intentionally left blank
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func addConstraintsToParent() {
        guard let view = view else {
            fatalError("Cannot constrain to parent: view has not been created yet")
        }
        
        guard let parentView = parent?.view else {
            fatalError("Cannot constrain to parent: no parent exists")
        }
        
        guard constraintsToParent.isEmpty else {
            fatalError("Already constrained to parent")
        }
        
        constraintsToParent = [
            view.topAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.topAnchor),
            view.bottomAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.trailingAnchor),
        ]
        
        parentView.addConstraints(constraintsToParent)
    }
    
    func removeConstraintsFromParent() {
        guard let parentView = parent?.view else {
            fatalError("Cannot remove constraints from parent: no parent exists")
        }
        
        parentView.removeConstraints(constraintsToParent)
        constraintsToParent = []
    }
    
    func configure(for card: Card) {
        self.card = card
    }
    
    // MARK: Actions
    @objc fileprivate func handleTap(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            delegate.flipCard(self)
        }
    }
    
    // MARK: Properties
    var side: CardSide {
        .front
    }
    
    private var constraintsToParent: [NSLayoutConstraint] = []
    
    fileprivate var delegate: CardViewControllerDelegate!
    fileprivate var contentLabel: UILabel!
    
    fileprivate var card: Card?
}


class FrontViewController: CardViewController {
    // MARK: View
    override func loadView() {
        view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = UIColor.red
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
        
        let frontLabel = UIView(frame: .zero)
        spacer.translatesAutoresizingMaskIntoConstraints = false
        
        contentLabel = UILabel(frame: .zero)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.textAlignment = .center
        contentLabel.numberOfLines = 0
        contentLabel.lineBreakMode = .byWordWrapping
        contentLabel.backgroundColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        contentLabel.text = "Front: No card loaded"
        
        let tapToFlipLabel = UILabel(frame: .zero)
        tapToFlipLabel.translatesAutoresizingMaskIntoConstraints = false
        tapToFlipLabel.font = tapToFlipLabel.font.withSize(12)
        tapToFlipLabel.textColor = tapToFlipLabel.textColor.withAlphaComponent(0.4)
        tapToFlipLabel.text = "(tap)"
        
        view.addSubview(spacer)
        view.addSubview(contentLabel)
        view.addSubview(tapToFlipLabel)
        view.addConstraints([
            spacer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            spacer.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            spacer.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.20),
            
            contentLabel.topAnchor.constraint(equalTo: spacer.bottomAnchor),
            contentLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            tapToFlipLabel.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 16),
            tapToFlipLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tapToFlipLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.bottomAnchor, constant: -2),
        ])
    }
    
    override func configure(for card: Card) {
        super.configure(for: card)
        contentLabel.text = card.frontContent
    }
    
    override var side: CardSide {
        get {
            .front
        }
        set (newValue) {
            //
        }
    }
    
}


class BackViewController: CardViewController {
    // MARK: View
    override func loadView() {
        view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = UIColor.blue
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
        
        contentLabel = UILabel(frame: .zero)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.numberOfLines = 0
        contentLabel.lineBreakMode = .byWordWrapping
        contentLabel.backgroundColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        contentLabel.text = "Back: No card loaded"
        
        view.addSubview(contentLabel)
        view.addConstraints([
            contentLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            contentLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            contentLabel.widthAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.widthAnchor)
        ])
    }
    
    override func configure(for card: Card) {
        super.configure(for: card)
        contentLabel.text = card.backContent
    }
    
    // MARK: Properties
    override var side: CardSide {
        .back
    }
}
