//
//  NewContentPackViewController.swift
//  FlashCards
//
//  Created by Work on 8/1/22.
//

import UIKit


class NewContentPackViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: Properties
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure TableView
        tableView.register(UINib(nibName: TextEntryCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: TextEntryCell.cellIdentifier)
        tableView.register(UINib(nibName: MultilineTextEntryCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: MultilineTextEntryCell.cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Row.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        
        switch Row.allCases[indexPath.row] as Row {
        case .title:
            let textEntryCell = tableView.dequeueReusableCell(withIdentifier: TextEntryCell.cellIdentifier, for: indexPath) as! TextEntryCell
            textEntryCell.configure(fieldIdentifier: "title")
            cell = textEntryCell
        case .author:
            let textEntryCell = tableView.dequeueReusableCell(withIdentifier: TextEntryCell.cellIdentifier, for: indexPath) as! TextEntryCell
            textEntryCell.configure(fieldIdentifier: "author")
            cell = textEntryCell
        case .description:
            let multilineTextEntryCell = tableView.dequeueReusableCell(withIdentifier: MultilineTextEntryCell.cellIdentifier, for: indexPath) as! MultilineTextEntryCell
            multilineTextEntryCell.configure(fieldIdentifier: "description")
            cell = multilineTextEntryCell
        }

        return cell
    }
    
    enum Row: CaseIterable {
        case title
        case author
        case description
    }
}
