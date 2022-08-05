//
//  NewContentPackViewController.swift
//  FlashCards
//
//  Created by Work on 8/1/22.
//

import UIKit


class FormViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FormCellDelegate {
    required init?(coder: NSCoder, formTitle title: String, formFields: [FormField], unwindIdentifier unwindID: String, saveHandler saveFunc: @escaping () -> Void) {
        formTitle = title
        fields = formFields
        unwindIdentifier = unwindID
        saveHandler = saveFunc
        
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Properties
    private var canSave: Bool {
        for field in self.fields {
            if field.required && field.value == "" {
                return false
            }
        }
        
        return true
    }
    
    private let formTitle: String
    private let fields: [FormField]
    private let unwindIdentifier: String
    private let saveHandler: () -> Void
    
    
    // MARK: IB
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var saveButton: UIBarButtonItem!
    
    @IBAction private func save(_ sender: UIBarButtonItem) {
        guard canSave else {
            fatalError("Save button should not be enabled if saving is not possible")
        }
        
        saveHandler()
        
        performSegue(withIdentifier: self.unwindIdentifier, sender: self)
    }
    
    // MARK: ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        navigationItem.title = formTitle
        updateSaveButton()
    }
    
    func updateSaveButton() {
        if canSave {
            saveButton.isEnabled = true
        }
        else {
            saveButton.isEnabled = false
        }
    }
    
    
    // MARK: TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fields.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let field = fields[indexPath.row]
        return generateCell(for: field, at: indexPath)
    }
    
    private func generateCell(for field: FormField, at indexPath: IndexPath) -> UITableViewCell {
        var formCell: FormCell
        
        switch field.type {
        case .title:
            formCell = tableView.dequeueReusableCell(withIdentifier: "FormTitleCell", for: indexPath) as! FormCell
        case .regular:
            formCell = tableView.dequeueReusableCell(withIdentifier: "FormRegularCell", for: indexPath) as! FormCell
        case .multiline:
            formCell = tableView.dequeueReusableCell(withIdentifier: "FormMultilineCell", for: indexPath) as! FormCell
        case .spacer:
            formCell = tableView.dequeueReusableCell(withIdentifier: "FormSpacerCell", for: indexPath) as! FormCell
        case .disclosure:
            formCell = tableView.dequeueReusableCell(withIdentifier: "FormDisclosureCell", for: indexPath) as! FormCell
        }
        
        formCell.configure(with: field, delegate: self)
        
        let cell = formCell as! UITableViewCell
        return cell
    }
    
    // MARK: FormCellDelegate
    func formCell(_ sender: FormCell, fieldDidChange field: FormField) {
        print(field.label, field.value)
        updateSaveButton()
    }
}
