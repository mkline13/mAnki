//
//  DeckListViewController.swift
//  FlashCards
//
//  Created by Work on 8/5/22.
//

import UIKit
import CoreData


class ContentPackListViewController: UIViewController, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    convenience init(flashCardService fcs: FlashCardService) {
        self.init(nibName: nil, bundle: nil)
        flashCardService = fcs
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
        let cell = tableView.dequeueReusableCell(withIdentifier: ContentPackListTableCell.reuseIdentifier, for: indexPath) as! ContentPackListTableCell
        
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
        tableView.register(ContentPackListTableCell.self, forCellReuseIdentifier: ContentPackListTableCell.reuseIdentifier)

        dataSource = EditingTableViewDiffableDataSource<Int, NSManagedObjectID>(tableView: tableView, cellProvider: provideCell, editHandler: handleEdit)
        resultsController = flashCardService.contentPackResultsController(with: self)
    }
    
    override func loadView() {
        title = "Content Packs"

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
        tabBarItem.image = UIImage(systemName: "books.vertical")
        tabBarItem.selectedImage = UIImage(systemName: "books.vertical.fill")
        
        // Nav bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addContentPack(_:)))
    }
    
    // MARK: Actions
    @objc private func addContentPack(_ sender: UIBarButtonItem) {
        let vc = ContentPackEditorViewController(flashCardService: flashCardService, contentPack: nil)
        show(vc, sender: self)
    }
    
    private func browseCards(_ pack: ContentPack) {
        let vc = CardBrowserViewController(for: pack, flashCardService: flashCardService)
        show(vc, sender: self)
    }
    
    // MARK: Properties
    private var flashCardService: FlashCardService!
    
    private var dataSource: UITableViewDiffableDataSource<Int, NSManagedObjectID>!
    private var resultsController: NSFetchedResultsController<ContentPack>!
    
    private var tableView: UITableView!
}


class ContentPackListTableCell: UITableViewCell {
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
    func configure(for contentPack: ContentPack) {
        label.text = contentPack.title
    }
    
    // MARK: Properties
    static let reuseIdentifier: String = "ContentPackListTableCell"
    private var label: UILabel!
}
