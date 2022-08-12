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
            title = "New Collection"
        }
        else {
            title = "Edit Collection"
        }
        
        view = UIView(frame: .zero)
        view.backgroundColor = .systemBackground
        
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        view.addSubview(scrollView)
        
        let content = UIView(frame: .zero)
        content.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(content)
        
        // Form views
        let stack = UIStackView(frame: .zero)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 16.0
        
        content.addSubview(stack)
        
        content.addConstraints([
            stack.topAnchor.constraint(equalTo: content.layoutMarginsGuide.topAnchor),
            stack.bottomAnchor.constraint(equalTo: content.layoutMarginsGuide.bottomAnchor),
            stack.centerXAnchor.constraint(equalTo: content.layoutMarginsGuide.centerXAnchor),
            stack.widthAnchor.constraint(equalTo: content.layoutMarginsGuide.widthAnchor, constant: -8),
        ])
        
        scrollView.addConstraints([
            content.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            content.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            content.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            content.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            content.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
        
        view.addConstraints([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
                
        // MARK: - Fields
        // Title field
        let updateTitleField: TitleField.UpdateHandler = { value in
            self.fields.title = value
            self.updateSaveButton()
        }
        let titleField = TitleField(placeholder: "Title", initial: self.fields.title, onUpdate: updateTitleField)
        titleField.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(titleField)
        stack.addArrangedSubview(Separator())
        
        // Author field
        let updateAuthorField: TextFieldWithLabel.UpdateHandler = { value in
            self.fields.author = value
            self.updateSaveButton()
        }
        let authorField = TextFieldWithLabel(labelText: "Author:", initial: self.fields.author, onUpdate: updateAuthorField)
        stack.addArrangedSubview(authorField)
        
        
        let sep1 = Separator()
        stack.addArrangedSubview(sep1)
        stack.setCustomSpacing(24, after: sep1)
        
        // Description field
        let updateDescriptionField: MultilineTextFieldWithLabel.UpdateHandler = { value in
            self.fields.packDescription = value
            self.updateSaveButton()
        }
        let descriptionView = MultilineTextFieldWithLabel(labelText: "Description:", initial: self.fields.packDescription, onUpdate: updateDescriptionField)
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(descriptionView)
        
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
