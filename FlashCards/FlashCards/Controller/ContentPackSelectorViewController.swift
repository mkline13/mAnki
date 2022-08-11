//
//  ContentPackSelectorViewController.swift
//  FlashCards
//
//  Created by Work on 8/11/22.
//

import UIKit
import CoreData


class ContentPackSelectorViewController: UIViewController, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    init(flashCardService: FlashCardService, selectionHandler: @escaping SelectionHandler) {
        super.init(nibName: nil, bundle: nil)
        self.flashCardService = flashCardService
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
        tableView.register(ContentPackListTableCell.self, forCellReuseIdentifier: ContentPackListTableCell.reuseIdentifier)
        tableView.allowsMultipleSelection = true
        
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: provideCell)
        resultsController = flashCardService.contentPackResultsController(with: self)
    }
    
    private func updateSaveButton() {
        saveButton.isEnabled = canSave
    }
    
    // MARK: UITableViewDelegate
    // Handle Row Selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }
        
        cell.accessoryType = .checkmark
        updateSaveButton()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }
        
        cell.accessoryType = .none
        updateSaveButton()
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    private func provideCell(for tableView: UITableView, _ indexPath: IndexPath, _ managedObjectID: NSManagedObjectID) -> UITableViewCell? {
        let contentPack = resultsController.managedObjectContext.object(with: managedObjectID) as! ContentPack
        let cell = tableView.dequeueReusableCell(withIdentifier: ContentPackListTableCell.reuseIdentifier, for: indexPath) as! ContentPackListTableCell
        
        let selectedIndexPaths = tableView.indexPathsForSelectedRows
        let rowIsSelected = selectedIndexPaths != nil && selectedIndexPaths!.contains(indexPath)
        cell.accessoryType = rowIsSelected ? .checkmark : .none
        updateSaveButton()
        
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
        
        for row in selectedRows {
            let pack = resultsController.object(at: row)
            self.selectionHandler(pack)
        }
        
        smartDismiss(animated: true)
    }
    
    
    // MARK: Properties
    private var flashCardService: FlashCardService!
    private var selectionHandler: SelectionHandler!
    
    private var dataSource: UITableViewDiffableDataSource<Int, NSManagedObjectID>!
    private var resultsController: NSFetchedResultsController<ContentPack>!
    
    private var tableView: UITableView!
    private var saveButton: UIBarButtonItem!
    
    private var canSave: Bool {
        if let rows = tableView.indexPathsForSelectedRows {
            return rows.count > 0
        }
        else {
            return false
        }
    }
    
    typealias SelectionHandler = (ContentPack) -> Void
}
