//
//  DeckListViewController.swift
//  FlashCards
//
//  Created by Work on 8/5/22.
//

import UIKit
import CoreData


class ContentPackListViewController: UIViewController, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    init(dependencyContainer dc: DependencyContainer) {
        dependencyContainer = dc
        flashCardService = dc.flashCardService
        
        tableView = UITableView(frame: .zero, style: .plain)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UITableViewDelegate
    // Handle Row Selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle UI
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Get data for new VC
        let contentPack = resultsController.object(at: indexPath)
        browseCards(contentPack)
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    private func provideCell(for tableView: UITableView, _ indexPath: IndexPath, _ managedObjectID: NSManagedObjectID) -> UITableViewCell? {
        let contentPack = resultsController.managedObjectContext.object(with: managedObjectID) as! ContentPack
        let cell = tableView.dequeueReusableCell(withIdentifier: ContentPackListCell.reuseIdentifier, for: indexPath) as! ContentPackListCell
        
        cell.configure(for: contentPack)
        return cell
    }
    
    private func handleEdit(for tableView: UITableView, editingStyle: UITableViewCell.EditingStyle, indexPath: IndexPath) {
        let managedObject = resultsController.object(at: indexPath)
        flashCardService.delete(managedObject)
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        let snapshot = snapshot as NSDiffableDataSourceSnapshot<Int, NSManagedObjectID>
        
        // animatingDifferences must be set to 'true' to prevent a crash on Mason's computer
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TableView
        tableView.delegate = self
        tableView.register(ContentPackListCell.self, forCellReuseIdentifier: ContentPackListCell.reuseIdentifier)

        dataSource = EditingTableViewDiffableDataSource<Int, NSManagedObjectID>(tableView: tableView, cellProvider: provideCell, editHandler: handleEdit)
        resultsController = flashCardService.contentPackResultsController(with: self)
    }
    
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
        tabBarItem.image = UIImage(systemName: "books.vertical")
        tabBarItem.selectedImage = UIImage(systemName: "books.vertical.fill")
        
        // Nav bar
        title = "Content Packs"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addContentPack(_:)))
        navigationItem.prompt = "Pick a pack to edit contents"
    }
    
    // MARK: Actions
    @objc private func addContentPack(_ sender: UIBarButtonItem) {
        let vc = ContentPackSettingsViewController(for: nil, flashCardService: flashCardService)
        show(vc, sender: self)
    }
    
    private func browseCards(_ pack: ContentPack) {
        let vc = CardBrowserViewController(for: pack, dependencyContainer: dependencyContainer)
        show(vc, sender: self)
    }
    
    // MARK: Properties
    private let dependencyContainer: DependencyContainer
    private let flashCardService: FlashCardService
    
    private var dataSource: UITableViewDiffableDataSource<Int, NSManagedObjectID>!
    private var resultsController: NSFetchedResultsController<ContentPack>!
    
    private let tableView: UITableView!
}

