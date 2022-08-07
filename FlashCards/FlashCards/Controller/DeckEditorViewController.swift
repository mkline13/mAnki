//
//  DeckEditorViewController.swift
//  FlashCards
//
//  Created by Work on 8/5/22.
//

import UIKit

class DeckEditorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FormFieldDelegate {
    convenience init(flashCardService fcs: FlashCardService, deck d: Deck?) {
        self.init(nibName: nil, bundle: nil)
        flashCardService = fcs
        deck = d
        
        if let deck = deck {
            results = DeckEditorResultsHandler(title: deck.title,
                                               deckDescription: deck.deckDescription,
                                               newCardsPerDay: deck.newCardsPerDay,
                                               reviewCardsPerDay: deck.reviewCardsLimit,
                                               flashCardService: flashCardService)
        }
        else {
            // Default Values
            results = DeckEditorResultsHandler(title: "",
                                               deckDescription: "",
                                               newCardsPerDay: 10,
                                               reviewCardsPerDay: 10,
                                               flashCardService: flashCardService)
        }
        
        hidesBottomBarWhenPushed = true
    }
    
    // MARK: FormFieldDelegate
    func formField(_ sender: FormField, key: Int, value: Any) {
        let field = DeckEditorField.allCases[key]
        switch field {
        case .title:
            results.title = value as! String
        case .deckDescription:
            results.deckDescription = value as! String
        case .newCardsPerDay:
            results.newCardsPerDay = value as! Int64
        case .reviewCardsPerDay:
            results.reviewCardsPerDay = value as! Int64
        }
        
        if results.canSave {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
        else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        DeckEditorField.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        let field = DeckEditorField.allCases[indexPath.row]
        
        switch field {
        case .title:
            let titleCell = tableView.dequeueReusableCell(withIdentifier: SingleLineTextEntryCell.reuseIdentifier, for: indexPath) as! SingleLineTextEntryCell
            titleCell.configure(label: "Title", key: field.rawValue, value: results.title, delegate: self)
            titleCell.font = UIFont.systemFont(ofSize: 17, weight: .bold)
            cell = titleCell
        case .deckDescription:
            let descriptionCell = tableView.dequeueReusableCell(withIdentifier: SingleLineTextEntryCell.reuseIdentifier, for: indexPath) as! SingleLineTextEntryCell
            descriptionCell.configure(label: "Description", key: field.rawValue, value: results.deckDescription, delegate: self)
            cell = descriptionCell
        case .newCardsPerDay:
            let ncpdCell = tableView.dequeueReusableCell(withIdentifier: StepperCell.reuseIdentifier, for: indexPath) as! StepperCell
            ncpdCell.configure(label: "New cards per day:", key: field.rawValue, value: results.newCardsPerDay, delegate: self)
            cell = ncpdCell
        case .reviewCardsPerDay:
            let rcpdCell = tableView.dequeueReusableCell(withIdentifier: StepperCell.reuseIdentifier, for: indexPath) as! StepperCell
            rcpdCell.configure(label: "Review cards per day:", key: field.rawValue, value: results.reviewCardsPerDay, delegate: self)
            cell = rcpdCell
        }
        
        return cell
    }
    
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
        table.register(SingleLineTextEntryCell.self, forCellReuseIdentifier: SingleLineTextEntryCell.reuseIdentifier)
        table.register(StepperCell.self, forCellReuseIdentifier: StepperCell.reuseIdentifier)
        table.register(SpacerCell.self, forCellReuseIdentifier: SpacerCell.reuseIdentifier)
        
        if deck == nil {
            title = "New Deck"
        }
        else {
            title = "Edit Deck"
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
        guard results.canSave else {
            return
        }
        
        if let deck = self.deck {
            results.update(deck: deck)
        }
        else {
            results.newDeck()
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
    
    // If deck == nil, then the editor display will be modified for editing a new deck
    private var deck: Deck?
    
    private var results: DeckEditorResultsHandler!
}

class DeckEditorResultsHandler {
    var title: String
    var deckDescription: String
    var newCardsPerDay: Int64
    var reviewCardsPerDay: Int64
    let flashCardService: FlashCardService
    
    init (title: String, deckDescription: String, newCardsPerDay: Int64, reviewCardsPerDay: Int64, flashCardService: FlashCardService) {
        self.title = title
        self.deckDescription = deckDescription
        self.newCardsPerDay = newCardsPerDay
        self.reviewCardsPerDay = reviewCardsPerDay
        self.flashCardService = flashCardService
    }
    
    func newDeck () {
        let _ = flashCardService.newDeck(title: title, description: deckDescription, newCardsPerDay: newCardsPerDay, reviewCardsPerDay: reviewCardsPerDay)
    }
    
    func update (deck: Deck) {
        flashCardService.updateDeck(deck, title: title, description: deckDescription, newCardsPerDay: newCardsPerDay, reviewCardsPerDay: reviewCardsPerDay)
    }
    
    var canSave: Bool {
        return (title != "")
    }
}


enum DeckEditorField: Int, CaseIterable {
    case title = 0
    case deckDescription
    case newCardsPerDay
    case reviewCardsPerDay
}
