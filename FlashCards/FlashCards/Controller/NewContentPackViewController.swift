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
        let offscreen = self.view.bounds.size.width
        let inset: CGFloat = 15
        
        switch Row.allCases[indexPath.row] as Row {
        case .spacer:
            let spacerCell = UITableViewCell()
            cell = spacerCell
            NSLayoutConstraint.activate([cell.heightAnchor.constraint(equalToConstant: 10.0)])
            cell.separatorInset = UIEdgeInsets(top: 0, left: offscreen, bottom: 0, right: 0)
        case .title:
            let textEntryCell = tableView.dequeueReusableCell(withIdentifier: TextEntryCell.cellIdentifier, for: indexPath) as! TextEntryCell
            textEntryCell.configure(fieldIdentifier: "title")
            cell = textEntryCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        case .author:
            let textEntryCell = tableView.dequeueReusableCell(withIdentifier: TextEntryCell.cellIdentifier, for: indexPath) as! TextEntryCell
            textEntryCell.configure(fieldIdentifier: "author")
            cell = textEntryCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        case .description:
            let multilineTextEntryCell = tableView.dequeueReusableCell(withIdentifier: MultilineTextEntryCell.cellIdentifier, for: indexPath) as! MultilineTextEntryCell
            multilineTextEntryCell.configure(fieldIdentifier: "description")
            cell = multilineTextEntryCell
            NSLayoutConstraint.activate([cell.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0)])
            cell.separatorInset = UIEdgeInsets(top: 0, left: offscreen, bottom: 0, right: 0)
        }

        return cell
    }
        
    enum Row: CaseIterable {
        case spacer
        case title
        case author
        case description
    }
}
