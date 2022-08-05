//
//  ContentPackListViewController.swift
//  FlashCards
//
//  Created by Work on 8/1/22.
//

import UIKit
import CoreData

class ContentPackListViewController: UIViewController, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    // MARK: Initializers
    required init? (coder: NSCoder, flashCardService cardService: FlashCardService) {
        // Inject Dependencies
        flashCardService = cardService
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Dependencies
    private let flashCardService: FlashCardService
    
    // MARK: Properties
    private var dataSource: UITableViewDiffableDataSource<Int, NSManagedObjectID>!
    private var resultsController: NSFetchedResultsController<ContentPack>!
    
    // MARK: - IB
    @IBOutlet private weak var tableView: UITableView!
    
    @IBSegueAction private func createNewContentPackViewController(coder: NSCoder) -> NewContentPackViewController? {
        return NewContentPackViewController(coder: coder, flashCardService: flashCardService)
    }
    
    @IBAction func unwindToContentPackListViewController(_ unwindSegue: UIStoryboardSegue) {
        // Intentionally Left Blank
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    
    // MARK: - NSFetchedResultsControllerDelegate
    private func provideCell(for tableView: UITableView, _ indexPath: IndexPath, _ managedObjectID: NSManagedObjectID) -> UITableViewCell? {
        let contentPack = try! resultsController.managedObjectContext.existingObject(with: managedObjectID) as! ContentPack
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContentPackCell", for: indexPath) as! ContentPackCell
        
        cell.configure(for: contentPack)
        return cell
    }
    
    private func handleEdit(for tableView: UITableView, editingStyle: UITableViewCell.EditingStyle, indexPath: IndexPath) {
        let managedObject = resultsController.object(at: indexPath)
        flashCardService.delete(managedObject)
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        let snapshot = snapshot as NSDiffableDataSourceSnapshot<Int, NSManagedObjectID>

        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = EditingTableViewDiffableDataSource<Int, NSManagedObjectID>(tableView: tableView, cellProvider: provideCell, editHandler: handleEdit)
        resultsController = flashCardService.contentPackResultsController(with: self)
    }
}
