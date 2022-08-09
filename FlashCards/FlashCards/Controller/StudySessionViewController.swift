//
//  StudySessionViewController.swift
//  FlashCards
//
//  Created by Work on 8/8/22.
//

import UIKit


class StudySessionViewController: UIViewController {
    init(for deck: Deck, FlashCardService: FlashCardService) {
        super.init(nibName: nil, bundle: nil)
        self.deck = deck
        self.flashCardService = FlashCardService
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View
    override func loadView() {
        title = "Study"
        
        view = UIView(frame: .zero)
        view.backgroundColor = UIColor.systemBackground
    }
    
    override func viewDidLoad() {
        //
    }
    
    // MARK: Embedded UIViewControllers
    private func createViewControllers(for card: Card) -> (UIViewController, UIViewController) {
        let frontViewController = FrontViewController(for: card)
        let backViewController = BackViewController(for: card)
        
        frontViewController.back = backViewController
        backViewController.front = frontViewController
        
        return (frontViewController, backViewController)
    }
    
    // MARK: Properties
    private var flashCardService: FlashCardService!
    private var deck: Deck!
    
    private var frontViewController: UIViewController?
}


class FrontViewController: UIViewController {
    init(for card: Card) {
        super.init(nibName: nil, bundle: nil)
        self.card = card
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View
    override func loadView() {
        view = UIView(frame: .zero)
        view.backgroundColor = UIColor.red
        
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        label.text = card.frontContent
        
        view.addSubview(label)
        view.addConstraints([
            label.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            label.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        ])
    }
    
    // MARK: Properties
    private var card: Card!
    var back: UIViewController!
}


class BackViewController: UIViewController {
    init(for card: Card) {
        super.init(nibName: nil, bundle: nil)
        self.card = card
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View
    override func loadView() {
        view = UIView(frame: .zero)
        view.backgroundColor = UIColor.red
        
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        label.text = card.frontContent
        
        view.addSubview(label)
        view.addConstraints([
            label.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            label.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        ])
    }
    
    // MARK: Properties
    private var card: Card!
    var front: UIViewController!
}
