//
//  CardEditorViewController.swift
//  FlashCards
//
//  Created by Work on 8/8/22.
//

import UIKit


class CardEditorViewController: UIViewController, UITextViewDelegate {
    init (in pack: ContentPack, dependencyContainer dc: DependencyContainer) {
        dependencyContainer = dc
        flashCardService = dc.flashCardService
        contentPack = pack
        
        frontContent = ""
        backContent = ""
        
        super.init(nibName: nil, bundle: nil)
    }
    
    init (for editCard: Card, dependencyContainer dc: DependencyContainer) {
        dependencyContainer = dc
        flashCardService = dc.flashCardService
        
        card = editCard
        contentPack = editCard.contentPack
        
        frontContent = editCard.frontContent
        backContent = editCard.backContent
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View
    override func loadView() {
        if card == nil {
            title = "New Card"
        }
        else {
            title = "Edit Card"
        }
        
        view = UIView(frame: .zero)
        view.backgroundColor = UIColor.systemBackground
        
        let layout = EZLayout(spacing: 16)
        view.addSubviewAndFitSafeTop(layout)
        
        layout.addSpacer()
                
        // Front content
        let frontContentUpdateHandler: MultilineTextFieldWithLabel.UpdateHandler = { text in
            self.frontContent = text
            self.updateSaveButton()
        }
        let frontContentField = MultilineTextFieldWithLabel(labelText: "Front:", initial: card?.frontContent ?? "", onUpdate: frontContentUpdateHandler)
        layout.addArrangedSubview(frontContentField)
        layout.addSeparator()
        
        // Back content
        let backContentUpdateHandler: MultilineTextFieldWithLabel.UpdateHandler = { text in
            self.backContent = text
            self.updateSaveButton()
        }
        let backContentField = MultilineTextFieldWithLabel(labelText: "Back:", initial: card?.backContent ?? "", onUpdate: backContentUpdateHandler)
        layout.addArrangedSubview(backContentField)
        layout.addSeparator()
        
        // In content pack label
        if let card = card {
            let infoView = InfoViewer(title: "Card info:")
            infoView.addLine(name: "content pack:") { "\(self.contentPack.title)" }
            infoView.addLine(name: "deck:") { "\(card.deck?.title ?? "(none)")" }
            infoView.addLine(name: "created:") { card.creationDate.formatted(date: .numeric, time: .omitted) }
            infoView.addLine(name: "times studied:") { "\(card.studyRecords.count)" }
            infoView.update()
            
            if let dueDate = card.srsDueDate {
                let color: UIColor
                if dueDate <= Date.now {
                    color = .systemRed
                }
                else {
                    color = .systemGreen
                }
                
                infoView.addLine(name: "due date:", contentColor: color) { dueDate.formatted(date: .numeric, time: .omitted) }
            }
            
            layout.addArrangedSubview(infoView)
        }

        
        // Nav Bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButton(_:)))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    private func updateSaveButton() {
        navigationItem.rightBarButtonItem?.isEnabled = canSave
    }
    
    // MARK: UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        updateSaveButton()
    }
    
    // MARK: Actions
    @objc private func saveButton(_ sender: UIBarButtonItem) {
        guard canSave else {
            return
        }
        
        if let card = card {
            flashCardService.updateCard(card, frontContent: frontContent, backContent: backContent)
        }
        else {
            _ = flashCardService.newCard(in: contentPack, frontContent: frontContent, backContent: backContent, deck: nil)
        }
        
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        }
        else {
            dismiss(animated: true)
        }
    }
    
    // MARK: Properties
    private var dependencyContainer: DependencyContainer
    private var flashCardService: FlashCardService
    
    private var contentPack: ContentPack
    private var card: Card? = nil
    
    private var frontContent: String
    private var backContent: String
    
    private var canSave: Bool {
        !frontContent.isEmpty
    }
}

