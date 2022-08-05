//
//  NewContentPackViewController.swift
//  FlashCards
//
//  Created by Work on 8/1/22.
//

import UIKit


class EditContentPackViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FormFieldCellDelegate {
    // MARK: Dependencies
    private let flashCardService: FlashCardService
    
    // MARK: Initializers
    required init? (coder: NSCoder, flashCardService cardService: FlashCardService) {
        // Inject Dependencies
        flashCardService = cardService
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Properties
    private var canSave: Bool {
        return formValues[.title] != ""
    }
    
    private var formValues: [Row: String] = [:]
    
    // MARK: IB
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var saveButton: UIBarButtonItem!
    
    @IBAction private func save(_ sender: UIBarButtonItem) {
        guard canSave else {
            return
        }
        
        let _ = flashCardService.newContentPack(withTitle: formValues[.title]!, packDescription: formValues[.packDescription]!, author: formValues[.author]!)
        
        performSegue(withIdentifier: "UnwindToContentPackList", sender: self)
    }
    
    
    // MARK: ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Prepare to receive form values
        for row in Row.allCases {
            formValues[row] = ""
        }
        
        // Configure TableView
        tableView.register(UINib(nibName: TextEntryCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: TextEntryCell.reuseIdentifier)
        tableView.register(UINib(nibName: MultilineTextEntryCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: MultilineTextEntryCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    
    // MARK: TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Row.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = Row.allCases[indexPath.row]
        
        if row == .spacer {
            return
        }
        else {
            let formFieldCell = tableView.dequeueReusableCell(withIdentifier: row.type.reuseIdentifier, for: indexPath) as! FormFieldCell
            formFieldCell.configure(fieldIndex: row.rawValue, labelText: row.label, delegate: self)

            return formFieldCell as! UITableViewCell
        }
    }
    
    enum Row: Int, CaseIterable {
        case title
        case author
        case packDescription
        case spacer
        case cards
        
        var label: String {
            switch self {
            case .title: return "Title"
            case .author: return "Author"
            case .packDescription: return "Description"
            case .spacer: return ""
            case .cards: return "Browse Cards"
            }
        }
        
        var type: FormFieldCell.Type {
            switch self {
            case .title: return TextEntryCell.self
            case .author: return TextEntryCell.self
            case .packDescription: return MultilineTextEntryCell.self
            }
        }
    }
    
    // MARK: FormFieldCellDelegate
    func formFieldCell(_ cell: FormFieldCell, valueDidChange newValue: String, fieldIndex index: Int) {
        let row = Row.allCases[index]
        let formattedValue = newValue.trimmingCharacters(in: .whitespaces)
        formValues[row] = formattedValue
        
        if row == .title {
            saveButton.isEnabled = !formattedValue.isEmpty
        }
    }
}


struct FormField {
    let id: Int
    let type: FormFieldType
    let label: String
}

enum FormFieldType: CaseIterable {
    case title
    case regular
    case multiline
    case spacer
    case disclosure
}
