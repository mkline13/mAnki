//
//  ContentPackSelectorViewController.swift
//  FlashCards
//
//  Created by Work on 8/11/22.
//

import UIKit
import CoreData


class ContentPackSelectorViewController: UIViewController, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    init(flashCardService: FlashCardService, selectionHandler: @escaping SelectionHandler, selectedContentPacks selection: Set<ContentPack>) {
        super.init(nibName: nil, bundle: nil)
        self.flashCardService = flashCardService
        self.selectedContentPacks = selection
        self.selectionHandler = selectionHandler
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - View
    override func loadView() {
        title = "Select Collections"
        
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
        
        // NavBar
        saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(save(_:)))
        saveButton.isEnabled = false
        navigationItem.rightBarButtonItem = saveButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TableView
        tableView.delegate = self
        tableView.register(ContentPackListCell.self, forCellReuseIdentifier: ContentPackListCell.reuseIdentifier)
        tableView.allowsMultipleSelection = true
        
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: provideCell)
        resultsController = flashCardService.contentPackResultsController(with: self)
    }
    
    private func updateSaveButton() {
        saveButton.isEnabled = true
    }
    
    // MARK: UITableViewDelegate
    // Handle Row Selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            fatalError("Could not get cell for selected row")
        }
        
        let contentPack = resultsController.object(at: indexPath)
        selectedContentPacks.insert(contentPack)
        
        cell.accessoryType = .checkmark
        updateSaveButton()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }
        
        let contentPack = resultsController.object(at: indexPath)
        selectedContentPacks.remove(contentPack)
        
        cell.accessoryType = .none
        updateSaveButton()
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    private func provideCell(for tableView: UITableView, _ indexPath: IndexPath, _ managedObjectID: NSManagedObjectID) -> UITableViewCell? {
        let contentPack = resultsController.managedObjectContext.object(with: managedObjectID) as! ContentPack
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ContentPackListCell.reuseIdentifier, for: indexPath) as! ContentPackListCell
        
        if selectedContentPacks.contains(contentPack) {
            cell.accessoryType = .checkmark
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        else {
            cell.accessoryType = .none
        }
        
        cell.configure(for: contentPack)
        return cell
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        let snapshot = snapshot as NSDiffableDataSourceSnapshot<Int, NSManagedObjectID>
        
        // animatingDifferences must be set to 'true' to prevent a crash on Mason's computer
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    // MARK: Actions
    @objc private func save(_ handler: UIBarButtonItem) {
        guard let selectedRows = tableView.indexPathsForSelectedRows else {
            return
        }
        
        let packs: Set<ContentPack> = Set(selectedRows.map { indexPath in
            return resultsController.object(at: indexPath)
        })
                
        self.selectionHandler(packs)
        
        smartDismiss(animated: true)
    }
    
    
    // MARK: Properties
    private var flashCardService: FlashCardService!
    private var selectionHandler: SelectionHandler!
    
    private var dataSource: UITableViewDiffableDataSource<Int, NSManagedObjectID>!
    private var resultsController: NSFetchedResultsController<ContentPack>!
    
    private var tableView: UITableView!
    private var saveButton: UIBarButtonItem!
    
    private var selectedContentPacks: Set<ContentPack>!
    
    typealias SelectionHandler = (Set<ContentPack>) -> Void
}
