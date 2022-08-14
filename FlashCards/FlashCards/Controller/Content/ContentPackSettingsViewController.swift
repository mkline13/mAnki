//
//  DeckSettingsViewControllerV2.swift
//  FlashCards
//
//  Created by Work on 8/10/22.
//

import UIKit


class ContentPackSettingsViewController: UIViewController {
    init (for contentPack: ContentPack?, flashCardService: FlashCardService) {
        super.init(nibName: nil, bundle: nil)
        
        if let contentPack = contentPack {
            self.fields = Fields(from: contentPack)
            self.contentPack = contentPack
        }
        else {
            self.fields = Fields()
            self.contentPack = nil
        }

        self.flashCardService = flashCardService
        
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View
    
    override func loadView() {
        if contentPack == nil {
            title = "New Content Pack"
        }
        else {
            title = "Content Pack Settings"
        }
        
        view = UIView(frame: .zero)
        view.backgroundColor = .systemBackground
        
        let layout = EZLayout(spacing: 16)
        
        view.addSubview(layout)
        view.addConstraints([
            layout.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            layout.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            layout.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            layout.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        // MARK: - Fields
        
        layout.addSpacer()
        
        // Title field
        let updateTitleField: TitleField.UpdateHandler = { value in
            self.fields.title = value
            self.updateSaveButton()
        }
        let titleField = TitleField(labelText: "Title:", placeholder: "Title", initial: self.fields.title, onUpdate: updateTitleField)
        titleField.translatesAutoresizingMaskIntoConstraints = false
        layout.addArrangedSubview(titleField)
        layout.addSeparator()
        
        // Description field
        let updateDescriptionField: MultilineTextFieldWithLabel.UpdateHandler = { value in
            self.fields.packDescription = value
            self.updateSaveButton()
        }
        let descriptionView = MultilineTextFieldWithLabel(labelText: "About:", initial: self.fields.packDescription, onUpdate: updateDescriptionField)
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        layout.addArrangedSubview(descriptionView)
        layout.addSeparator()
        
        // Author field
        let updateAuthorField: TextFieldWithLabel.UpdateHandler = { value in
            self.fields.author = value
            self.updateSaveButton()
        }
        let authorField = TextFieldWithLabel(labelText: "Author:", initial: self.fields.author, onUpdate: updateAuthorField)
        layout.addArrangedSubview(authorField)
        
        layout.addSeparator()
        
        // USEFUL FOR DEBUGGING
//        for subview in stack.arrangedSubviews {
//            subview.backgroundColor = .systemPink
//        }
        
        // NavBar
        saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(save(_:)))
        saveButton.isEnabled = false
        navigationItem.rightBarButtonItem = saveButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func updateSaveButton() {
        saveButton.isEnabled = canSave
    }
    
    // MARK: Actions
    @objc private func save(_ sender: UIBarButtonItem) {
        if let pack = contentPack {
            flashCardService.updateContentPack(pack,
                                               title: fields.title,
                                               description: fields.packDescription,
                                               author: fields.author)
        }
        else {
            let _ = flashCardService.newContentPack(title: fields.title, description: fields.packDescription, author: fields.author)
        }
        
        smartDismiss(animated: true)
    }
    
    // MARK: Properties
    private var contentPack: ContentPack?
    private var flashCardService: FlashCardService!
        
    private var fields: Fields!
    
    var canSave: Bool {
        fields.title != ""
    }
    
    private var saveButton: UIBarButtonItem!
    
    // MARK: Types
    struct Fields {
        init (from contentPack: ContentPack) {
            title = contentPack.title
            packDescription = contentPack.packDescription
            author = contentPack.author
        }
        
        init () {
            title = ""
            packDescription = ""
            author = ""
        }
        
        var title: String
        var packDescription: String
        var author: String
    }
}
