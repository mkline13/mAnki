//
//  CardBrowserViewController.swift
//  FlashCards
//
//  Created by Work on 8/7/22.
//

import UIKit


class CardBrowserViewController: UIViewController {
    init (flashCardService: FlashCardService) {
        super.init(nibName: nil, bundle: nil)
        
        self.flashCardService = flashCardService
        hidesBottomBarWhenPushed = true
    }
        
    convenience init (for deck: Deck, flashCardService: FlashCardService) {
        self.init(flashCardService: flashCardService)
        self.deck = deck
    }
    
    convenience init (for pack: ContentPack, flashCardService: FlashCardService) {
        self.init(flashCardService: flashCardService)
        self.contentPack = pack
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View
    override func loadView() {
        title = "Cards"
        
        view = UIView(frame: .zero)
        view.backgroundColor = UIColor.systemBackground
        
        tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        view.addConstraints([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settingsButton(_:)))
                
        if let deck = deck {
            var subtitleText = deck.title.prefix(20)
            if subtitleText.count != deck.title.count {
                subtitleText += "..."
            }
            navigationItem.titleView = createTitleView(title: "Cards", subtitle: "in \"\(subtitleText)\"")
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
        else if let contentPack = contentPack {
            var subtitleText = contentPack.title.prefix(20)
            if subtitleText.count != contentPack.title.count {
                subtitleText += "..."
            }
            navigationItem.titleView = createTitleView(title: "Cards", subtitle: "in \"\(subtitleText)\"")
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
        else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
    }
    
    private func createTitleView(title: String, subtitle: String) -> UIView {
        let titleView = UIView(frame: .zero)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.backgroundColor = UIColor.clear
        
        let bigLabel = UILabel(frame: .zero)
        bigLabel.translatesAutoresizingMaskIntoConstraints = false
        bigLabel.text = title
        bigLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        bigLabel.textAlignment = .center
        
        let smallLabel = UILabel(frame: .zero)
        smallLabel.translatesAutoresizingMaskIntoConstraints = false
        smallLabel.text = subtitle
        smallLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        smallLabel.textAlignment = .center
        
        titleView.addSubview(bigLabel)
        titleView.addSubview(smallLabel)
        titleView.addConstraints([
            bigLabel.topAnchor.constraint(equalTo: titleView.topAnchor),
            bigLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
            bigLabel.trailingAnchor.constraint(equalTo: titleView.trailingAnchor),
            
            smallLabel.topAnchor.constraint(equalTo: bigLabel.bottomAnchor, constant: 2),
            smallLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor),
            smallLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
            smallLabel.trailingAnchor.constraint(equalTo: titleView.trailingAnchor),
        ])
        
        return titleView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Actions
    @objc private func settingsButton(_ sender: UIBarButtonItem) {
        if let deck = deck {
            let vc = DeckEditorViewController(flashCardService: flashCardService, deck: deck)
            show(vc, sender: self)
        }
        else if let contentPack = contentPack {
            let vc = ContentPackEditorViewController(flashCardService: flashCardService, contentPack: contentPack)
            show(vc, sender: self)
        }
        else {
            fatalError("Expected either contentPack or deck to exist. Settings button should be disabled")
        }
    }
    
    // MARK: Properties
    private var flashCardService: FlashCardService!
    private var deck: Deck? = nil
    private var contentPack: ContentPack? = nil
    
    private var tableView: UITableView!
}
