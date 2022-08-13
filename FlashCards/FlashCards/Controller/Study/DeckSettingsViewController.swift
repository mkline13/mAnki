//
//  DeckSettingsViewControllerV2.swift
//  FlashCards
//
//  Created by Work on 8/10/22.
//

import UIKit


class DeckSettingsViewController: UIViewController {
    init (for deck: Deck?, flashCardService: FlashCardService) {
        super.init(nibName: nil, bundle: nil)
        
        if let deck = deck {
            self.fields = Fields(from: deck)
            self.deck = deck
        }
        else {
            self.fields = Fields()
            self.deck = nil
        }

        self.flashCardService = flashCardService
        
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View
    
    override func loadView() {
        if deck == nil {
            title = "New Deck"
        }
        else {
            title = "Edit Deck"
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
        
        
        // NewCardsPerDay field
        let newCardsPerDayAction: StepperField.UpdateHandler = { value in
            self.fields.newCardsPerDay = value
            self.updateSaveButton()
        }
        let newCardsPerDayView = StepperField(labelText: "New Cards / Day:", initial: self.fields.newCardsPerDay, onUpdate: newCardsPerDayAction)
        newCardsPerDayView.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(newCardsPerDayView)
        
        
        // ReviewCardsPerDay field
        let reviewCardsPerDayAction: StepperField.UpdateHandler = { value in
            self.fields.reviewCardsPerDay = value
            self.updateSaveButton()
        }
        let reviewCardsPerDayView = StepperField(labelText: "Review Cards / Day:", initial: self.fields.reviewCardsPerDay, onUpdate: reviewCardsPerDayAction)
        reviewCardsPerDayView.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(reviewCardsPerDayView)
        
        let sep = Separator()
        stack.addArrangedSubview(sep)
        stack.setCustomSpacing(24, after: sep)
        
        
        // Associated ContentPacks
        let addButtonAction = UIAction { _ in
            let updateHandler: ContentPackSelectorViewController.SelectionHandler = { packs in
                self.fields.associatedContentPacks = packs
                self.updateSaveButton()
            }
            let vc = ContentPackSelectorViewController(flashCardService: self.flashCardService, selectionHandler: updateHandler, selectedContentPacks: self.fields.associatedContentPacks)
            self.show(vc, sender: self)
        }
        
        let addButton = UIButton(primaryAction: addButtonAction)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        let addButtonImage = UIImage(systemName: "plus.circle")
        addButton.setImage(addButtonImage, for: .normal)
        
        contentPackListView = CollectionViewer(labelText: "Associated Collections:", button: addButton)
        stack.addArrangedSubview(contentPackListView)
        stack.setCustomSpacing(24, after: contentPackListView)
        
        let sep1 = Separator()
        stack.addArrangedSubview(sep1)
        stack.setCustomSpacing(24, after: sep1)
        
        // Description field
        let updateDescriptionField: MultilineTextFieldWithLabel.UpdateHandler = { value in
            self.fields.deckDescription = value
            self.updateSaveButton()
        }
        let descriptionView = MultilineTextFieldWithLabel(labelText: "Description:", initial: self.fields.deckDescription, onUpdate: updateDescriptionField)
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
    
    override func viewWillAppear(_ animated: Bool) {
        updateContentPackView()
    }
    
    private func updateSaveButton() {
        saveButton.isEnabled = canSave
    }
    
    private func updateContentPackView() {
        var titleStrings: [String] = self.fields.associatedContentPacks.map { pack in
            return pack.title
        }
        
        titleStrings.sort()
        
        self.contentPackListView.update(with: titleStrings)
    }
    
    // MARK: Actions
    @objc private func save(_ sender: UIBarButtonItem) {
        if let deck = deck {
            flashCardService.updateDeck(deck,
                                        title: fields.title,
                                        description: fields.deckDescription,
                                        newCardsPerDay: fields.newCardsPerDay,
                                        reviewCardsPerDay: fields.reviewCardsPerDay)
            
            flashCardService.set(contentPacks: fields.associatedContentPacks, for: deck)
        }
        else if let deck = flashCardService.newDeck(title: fields.title,
                                                    description: fields.deckDescription,
                                                    newCardsPerDay: fields.newCardsPerDay,
                                                    reviewCardsPerDay: fields.reviewCardsPerDay) {
            
            flashCardService.set(contentPacks: fields.associatedContentPacks, for: deck)
        }
        
        smartDismiss(animated: true)
    }
    
    // MARK: Properties
    private var deck: Deck?
    private var flashCardService: FlashCardService!
    
    private var contentPackListView: CollectionViewer!
    
    private var fields: Fields!
    
    var canSave: Bool {
        fields.title != ""
    }
    
    private var saveButton: UIBarButtonItem!
    
    // MARK: Types
    struct Fields {
        init (from deck: Deck) {
            title = deck.title
            deckDescription = deck.deckDescription
            newCardsPerDay = deck.newCardsPerDay
            reviewCardsPerDay = deck.reviewCardsPerDay
            associatedContentPacks = deck.associatedContentPacks as! Set<ContentPack>
        }
        
        init () {
            title = ""
            deckDescription = ""
            newCardsPerDay = 10
            reviewCardsPerDay = 25
            associatedContentPacks = Set()
        }
        
        var title: String
        var deckDescription: String
        var newCardsPerDay: Int64
        var reviewCardsPerDay: Int64
        var associatedContentPacks: Set<ContentPack>
    }
}
