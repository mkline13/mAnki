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
    
    // MARK: UITableViewDelegate
    // Handle Row Selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle UI
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Get data for new VC
        let deck = resultsController.object(at: indexPath)
        let vc = DeckEditorViewController(flashCardService: flashCardService, deck: deck)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    private func provideCell(for tableView: UITableView, _ indexPath: IndexPath, _ managedObjectID: NSManagedObjectID) -> UITableViewCell? {
//        print(try? resultsController.managedObjectContext.count(for: NSFetchRequest<NSFetchRequestResult>))
        guard let deckResult = try? resultsController.managedObjectContext.existingObject(with: managedObjectID) else {
            return
        }
        
        let deck = deckResult as! Deck
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

        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TableView
        table.delegate = self
        table.register(DeckListTableCell.self, forCellReuseIdentifier: DeckListTableCell.reuseIdentifier)

        dataSource = EditingTableViewDiffableDataSource<Int, NSManagedObjectID>(tableView: table, cellProvider: provideCell, editHandler: handleEdit)
        resultsController = flashCardService.deckResultsController(with: self)
    }
    
    override func loadView() {
        title = "Study Decks"
        view = UIView(frame: .zero)
        view.backgroundColor = UIColor.systemBackground
        
        // TableView
        table = UITableView(frame: .zero, style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(table)
        view.addConstraints([
            table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        // Tab bar
        tabBarItem.image = UIImage(systemName: "studentdesk")
        tabBarItem.selectedImage = tabBarItem.image
        
        // Nav bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDeck(_:)))
    }
    
    // MARK: Actions
    @objc private func addDeck(_ sender: UIBarButtonItem) {
        let vc = DeckEditorViewController(flashCardService: flashCardService, deck: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: Properties
    private var flashCardService: FlashCardService!
    
    private var dataSource: UITableViewDiffableDataSource<Int, NSManagedObjectID>!
    private var resultsController: NSFetchedResultsController<Deck>!
    
    private var table: UITableView!
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
