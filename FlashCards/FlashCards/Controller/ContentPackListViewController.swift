//
//  ContentPackListViewController.swift
//  FlashCards
//
//  Created by Work on 8/1/22.
//

import UIKit
import CoreData

class ContentPackListViewController: UIViewController {
    // MARK: Dependencies
    private let flashCardService: FlashCardService
    
    // MARK: Properties
    private var dataSource: UITableViewDiffableDataSource<Int, NSManagedObjectID>!
    private var resultsController: NSFetchedResultsController<ContentPack>!
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: IBSegueActions
    
    
    // MARK: Initializers
    required init? (coder: NSCoder, flashCardService cardService: FlashCardService) {
        // Inject Dependencies
        flashCardService = cardService
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
