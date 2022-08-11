//
//  DeckListViewController.swift
//  FlashCards
//
//  Created by Work on 8/5/22.
//

import UIKit
import CoreData


class DeckListViewController: UIViewController, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    convenience init(flashCardService fcs: FlashCardService) {
        self.init(nibName: nil, bundle: nil)
        flashCardService = fcs
    }
    
    // MARK: - View
    override func loadView() {
        title = "Study Decks"
        view = UIView(frame: .zero)
        view.backgroundColor = UIColor.systemBackground
        
        // TableView
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        view.addConstraints([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        // Tab bar
        tabBarItem.image = UIImage(systemName: "book")
        tabBarItem.selectedImage = UIImage(systemName: "book.fill")
        
        // Nav bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDeck(_:)))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TableView
        tableView.delegate = self
        tableView.register(DeckListTableCell.self, forCellReuseIdentifier: DeckListTableCell.reuseIdentifier)

        dataSource = EditingTableViewDiffableDataSource<Int, NSManagedObjectID>(tableView: tableView, cellProvider: provideCell, editHandler: handleEdit)
        resultsController = flashCardService.deckResultsController(with: self)
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        resultsController.delegate = self
//        try! resultsController.performFetch()
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        resultsController.delegate = nil
//    }
    
    // MARK: UITableViewDelegate
    // Handle Row Selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle UI
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Get data for new VC
        let deck = resultsController.object(at: indexPath)
        studyDeck(deck)
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    private func provideCell(for tableView: UITableView, _ indexPath: IndexPath, _ managedObjectID: NSManagedObjectID) -> UITableViewCell? {
        let deck = resultsController.managedObjectContext.object(with: managedObjectID) as! Deck
        let cell = tableView.dequeueReusableCell(withIdentifier: DeckListTableCell.reuseIdentifier, for: indexPath) as! DeckListTableCell
        
        cell.configure(for: deck)
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
    
    // MARK: Actions
    @objc private func addDeck(_ sender: UIBarButtonItem) {
        let vc = DeckSettingsViewController(for: nil, flashCardService: flashCardService)
        show(vc, sender: self)
    }
    
    private func studyDeck(_ deck: Deck) {
        let vc = StudySessionLauncherViewController(for: deck, flashCardService: flashCardService)
        show(vc, sender: self)
    }
    
    // MARK: Properties
    private var flashCardService: FlashCardService!
    
    private var dataSource: UITableViewDiffableDataSource<Int, NSManagedObjectID>!
    private var resultsController: NSFetchedResultsController<Deck>!
    
    private var tableView: UITableView!
}



class DeckListTableCell: UITableViewCell {
    // MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.accessoryType = .disclosureIndicator
        
        label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(label)
        contentView.addConstraints([
            label.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            label.trailingAnchor.constraint(lessThanOrEqualTo: contentView.layoutMarginsGuide.trailingAnchor),
        ])
        
        label.font = label.font.withSize(14)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View
    func configure(for deck: Deck) {
        label.text = deck.title
    }
    
    // MARK: Properties
    static let reuseIdentifier: String = "DeckListTableCell"
    private var label: UILabel!
}
