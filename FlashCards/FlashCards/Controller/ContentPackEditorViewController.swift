//
//  ContentPackEditorViewController.swift
//  FlashCards
//
//  Created by Work on 8/5/22.
//

import UIKit

class ContentPackEditorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FormFieldDelegate {
    convenience init(flashCardService fcs: FlashCardService, contentPack pack: ContentPack?) {
        self.init(nibName: nil, bundle: nil)
        flashCardService = fcs
        contentPack = pack
        
        if let pack = contentPack {
            resultsHandler = ContentPackEditorResultsHandler(title: pack.title,
                                                             packDescription: pack.packDescription,
                                                             author: pack.author,
                                                             flashCardService: flashCardService)
        }
        else {
            // Default Values
            resultsHandler = ContentPackEditorResultsHandler(title: "",
                                                             packDescription: "",
                                                             author: "",
                                                             flashCardService: flashCardService)
        }
        
        hidesBottomBarWhenPushed = true
    }
    
    // MARK: FormFieldDelegate
    func formField(_ sender: FormField, key: Int, value: Any) {
        let field = ContentPackEditorField.allCases[key]
        switch field {
        case .title:
            resultsHandler.title = value as! String
        case .author:
            resultsHandler.author = value as! String
        case .packDescription:
            resultsHandler.packDescription = value as! String
        }
        
        if resultsHandler.canSave {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
        else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ContentPackEditorField.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        let field = ContentPackEditorField.allCases[indexPath.row]
        
        switch field {
        case .title:
            let titleCell = tableView.dequeueReusableCell(withIdentifier: SingleLineTextEntryCell.reuseIdentifier, for: indexPath) as! SingleLineTextEntryCell
            titleCell.configure(label: "Title", key: field.rawValue, value: resultsHandler.title, delegate: self)
            titleCell.font = UIFont.systemFont(ofSize: 17, weight: .bold)
            cell = titleCell
        case .packDescription:
            let descriptionCell = tableView.dequeueReusableCell(withIdentifier: SingleLineTextEntryCell.reuseIdentifier, for: indexPath) as! SingleLineTextEntryCell
            descriptionCell.configure(label: "Description", key: field.rawValue, value: resultsHandler.packDescription, delegate: self)
            cell = descriptionCell
        case .author:
            let authorCell = tableView.dequeueReusableCell(withIdentifier: SingleLineTextEntryCell.reuseIdentifier, for: indexPath) as! SingleLineTextEntryCell
            authorCell.configure(label: "Author", key: field.rawValue, value: resultsHandler.author, delegate: self)
            cell = authorCell
        }
        
        return cell
    }
    
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
        table.register(SingleLineTextEntryCell.self, forCellReuseIdentifier: SingleLineTextEntryCell.reuseIdentifier)
        
        if contentPack == nil {
            title = "New Content Pack"
        }
        else {
            title = "Content Pack Settings"
        }
    }
    
    override func loadView() {
        view = UIView(frame: .zero)
        view.backgroundColor = UIColor.systemBackground
        
        table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(table)
        view.addConstraints([
            table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(save(_:)))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    // MARK: Actions
    @objc private func save(_ sender: UIBarButtonItem) {
        guard resultsHandler.canSave else {
            return
        }
        
        if let pack = self.contentPack {
            resultsHandler.update(pack)
        }
        else {
            resultsHandler.new()
        }
        
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        }
        else {
            dismiss(animated: true)
        }
    }
    
    // MARK: Properties
    private var flashCardService: FlashCardService!
    private var table: UITableView!
    
    // If contentPack == nil, then the editor display will be modified for editing a new contentPack
    private var contentPack: ContentPack?
    
    private var resultsHandler: ContentPackEditorResultsHandler!
}

class ContentPackEditorResultsHandler {
    var title: String
    var packDescription: String
    var author: String
    let flashCardService: FlashCardService
    
    init (title: String, packDescription: String, author: String, flashCardService: FlashCardService) {
        self.title = title
        self.packDescription = packDescription
        self.author = author
        
        self.flashCardService = flashCardService
    }
    
    func new () {
        let _ = flashCardService.newContentPack(title: title, description: packDescription, author: author)
    }
    
    func update (_ pack: ContentPack) {
        flashCardService.updateContentPack(pack, title: title, description: packDescription, author: author)
    }
    
    var canSave: Bool {
        return (title != "")
    }
}


enum ContentPackEditorField: Int, CaseIterable {
    case title = 0
    case author
    case packDescription
}
