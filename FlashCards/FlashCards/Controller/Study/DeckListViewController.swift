//
//  DeckListViewController.swift
//  FlashCards
//
//  Created by Work on 8/5/22.
//

import UIKit
import CoreData


class DeckListViewController: UIViewController, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    init(dependencyContainer dc: DependencyContainer) {
        dependencyContainer = dc
        flashCardService = dependencyContainer.flashCardService
        srsService = dependencyContainer.srsService
        
        tableView = UITableView(frame: .zero, style: .plain)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View
    override func loadView() {
        view = UIView(frame: .zero)
        view.backgroundColor = UIColor.systemBackground
        
        // TableView
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
        title = "Decks"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDeck(_:)))
//        navigationItem.prompt = "Pick a deck to begin studying"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TableView
        tableView.delegate = self
        tableView.register(DeckListCell.self, forCellReuseIdentifier: DeckListCell.reuseIdentifier)

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
        let cell = tableView.dequeueReusableCell(withIdentifier: DeckListCell.reuseIdentifier, for: indexPath) as! DeckListCell
        
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
        let vc = StudySessionLauncherViewController(for: deck, dependencyContainer: dependencyContainer)
        show(vc, sender: self)
    }
    
    // MARK: Properties
    private let dependencyContainer: DependencyContainer
    private let flashCardService: FlashCardService
    private let srsService: SRSService
    
    private var dataSource: UITableViewDiffableDataSource<Int, NSManagedObjectID>!
    private var resultsController: NSFetchedResultsController<Deck>!
    
    private let tableView: UITableView
}
