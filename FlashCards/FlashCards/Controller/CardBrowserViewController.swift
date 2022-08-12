//
//  CardBrowserViewController.swift
//  FlashCards
//
//  Created by Work on 8/7/22.
//

import UIKit
import CoreData


class CardBrowserViewController: UIViewController, UITableViewDelegate, NSFetchedResultsControllerDelegate {
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
    
    // MARK: - View
    override func loadView() {
        title = "Cards"
        
        view = UIView(frame: .zero)
        view.backgroundColor = UIColor.systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settingsButton(_:)))
                
        if let deck = deck {
            var subtitleText = deck.title.prefix(20)
            if subtitleText.count != deck.title.count {
                subtitleText += "..."
            }
            navigationItem.titleView = createTitleView(title: "Cards", subtitle: "Deck: \(subtitleText)")
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
        else if let contentPack = contentPack {
            var subtitleText = contentPack.title.prefix(20)
            if subtitleText.count != contentPack.title.count {
                subtitleText += "..."
            }
            navigationItem.titleView = createTitleView(title: "Cards", subtitle: "Collection: \(subtitleText)")
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
        else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
        tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let toolbar = UIToolbar(frame: CGRect.infinite)  // CGRect.infinite fixes a weird autoresizing constraint bug
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        
        if deck == nil {
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
            let newCardButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(newCardButton(_:)))
            toolbar.items = [flexibleSpace, newCardButton]
        }
        
        view.addSubview(tableView)
        view.addSubview(toolbar)
        view.addConstraints([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: toolbar.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            toolbar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
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
        
        // TableView
        tableView.delegate = self
        tableView.register(CardBrowserCell.self, forCellReuseIdentifier: CardBrowserCell.reuseIdentifier)
        
        dataSource = EditingTableViewDiffableDataSource<Int, NSManagedObjectID>(tableView: tableView, cellProvider: provideCell, editHandler: handleEdit)
                
        if let deck = deck {
            resultsController = flashCardService.cardResultsController(with: self, for: deck)
        }
        else if let contentPack = contentPack {
            resultsController = flashCardService.cardResultsController(with: self, for: contentPack)
        }
        else {
            resultsController = flashCardService.cardResultsController(with: self)
        }
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle UI
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Get data for new VC
        let card = resultsController.object(at: indexPath)
        editCard(card)
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    private func provideCell(for tableView: UITableView, _ indexPath: IndexPath, _ managedObjectID: NSManagedObjectID) -> UITableViewCell? {
        let card = resultsController.managedObjectContext.object(with: managedObjectID) as! Card
        let cell = tableView.dequeueReusableCell(withIdentifier: CardBrowserCell.reuseIdentifier, for: indexPath) as! CardBrowserCell
        
        cell.configure(for: card)
        return cell
    }
    
    private func handleEdit(for tableView: UITableView, editingStyle: UITableViewCell.EditingStyle, indexPath: IndexPath) {
        let managedObject = resultsController.object(at: indexPath)
        flashCardService.delete(managedObject)
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        let snapshot = snapshot as NSDiffableDataSourceSnapshot<Int, NSManagedObjectID>
        
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    
    // MARK: - Actions
    @objc private func settingsButton(_ sender: UIBarButtonItem) {
        if let deck = deck {
            let vc = DeckSettingsViewController(for: deck, flashCardService: flashCardService)
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
    
    @objc private func newCardButton(_ sender: UIBarButtonItem) {
        guard let contentPack = contentPack else {
            fatalError("New card creation must only happen from the ContentPack card browser")
        }
        
        let vc = CardEditorViewController(in: contentPack, flashCardService: flashCardService)
        show(vc, sender: self)
    }
    
    private func editCard(_ card: Card) {
        let vc = CardEditorViewController(for: card, flashCardService: flashCardService)
        show(vc, sender: self)
    }
    
    // MARK: - Properties
    private var flashCardService: FlashCardService!
    private var deck: Deck? = nil
    private var contentPack: ContentPack? = nil
    
    private var tableView: UITableView!
    
    private var dataSource: UITableViewDiffableDataSource<Int, NSManagedObjectID>!
    private var resultsController: NSFetchedResultsController<Card>!
}
