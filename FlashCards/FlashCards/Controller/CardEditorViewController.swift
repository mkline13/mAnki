//
//  CardEditorViewController.swift
//  FlashCards
//
//  Created by Work on 8/8/22.
//

import UIKit


class CardEditorViewController: UIViewController, UITextViewDelegate {
    init (in pack: ContentPack, flashCardService: FlashCardService) {
        super.init(nibName: nil, bundle: nil)
        self.flashCardService = flashCardService
        self.contentPack = pack
    }
    
    init (for card: Card, flashCardService: FlashCardService) {
        super.init(nibName: nil, bundle: nil)
        self.flashCardService = flashCardService
        self.card = card
        self.contentPack = card.contentPack
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
        
        let cornerRadius = 4.0
        let borderColor = CGColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        let borderWidth = 0.4
        let labelFont = UIFont.systemFont(ofSize: 17, weight: .bold)
        let inset = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        
        // Front
        let frontPanel = UIView(frame: .zero)
        frontPanel.translatesAutoresizingMaskIntoConstraints = false
        
        let frontLabel = UILabel(frame: .zero)
        frontLabel.translatesAutoresizingMaskIntoConstraints = false
        frontLabel.font = labelFont
        frontLabel.text = "Front"
        
        frontContent = UITextView(frame: .zero)
        frontContent.translatesAutoresizingMaskIntoConstraints = false
        frontContent.layer.cornerRadius = cornerRadius
        frontContent.layer.borderColor = borderColor
        frontContent.layer.borderWidth = borderWidth
        frontContent.contentInset = inset

        frontPanel.addSubview(frontLabel)
        frontPanel.addSubview(frontContent)
        frontPanel.addConstraints([
            frontLabel.topAnchor.constraint(equalTo: frontPanel.layoutMarginsGuide.topAnchor),
            frontLabel.leadingAnchor.constraint(equalTo: frontPanel.layoutMarginsGuide.leadingAnchor),
            frontLabel.trailingAnchor.constraint(equalTo: frontPanel.layoutMarginsGuide.trailingAnchor),
            
            frontContent.topAnchor.constraint(equalTo: frontLabel.bottomAnchor, constant: 8),
            frontContent.bottomAnchor.constraint(equalTo: frontPanel.layoutMarginsGuide.bottomAnchor),
            frontContent.leadingAnchor.constraint(equalTo: frontPanel.layoutMarginsGuide.leadingAnchor),
            frontContent.trailingAnchor.constraint(equalTo: frontPanel.layoutMarginsGuide.trailingAnchor),
        ])
        
        // Back
        let backPanel = UIView(frame: .zero)
        backPanel.translatesAutoresizingMaskIntoConstraints = false
        
        let backLabel = UILabel(frame: .zero)
        backLabel.translatesAutoresizingMaskIntoConstraints = false
        backLabel.font = labelFont
        backLabel.text = "Back"
        
        backContent = UITextView(frame: .zero)
        backContent.translatesAutoresizingMaskIntoConstraints = false
        backContent.layer.cornerRadius = cornerRadius
        backContent.layer.borderColor = borderColor
        backContent.layer.borderWidth = borderWidth
        backContent.contentInset = inset
        
        backPanel.addSubview(backLabel)
        backPanel.addSubview(backContent)
        backPanel.addConstraints([
            backLabel.topAnchor.constraint(equalTo: backPanel.layoutMarginsGuide.topAnchor),
            backLabel.leadingAnchor.constraint(equalTo: backPanel.layoutMarginsGuide.leadingAnchor),
            backLabel.trailingAnchor.constraint(equalTo: backPanel.layoutMarginsGuide.trailingAnchor),
            
            backContent.topAnchor.constraint(equalTo: backLabel.bottomAnchor, constant: 8),
            backContent.bottomAnchor.constraint(equalTo: backPanel.layoutMarginsGuide.bottomAnchor),
            backContent.leadingAnchor.constraint(equalTo: backPanel.layoutMarginsGuide.leadingAnchor),
            backContent.trailingAnchor.constraint(equalTo: backPanel.layoutMarginsGuide.trailingAnchor),
        ])
        
        view.addSubview(frontPanel)
        view.addSubview(backPanel)
        view.addConstraints([
            frontPanel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            frontPanel.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5),
            frontPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            frontPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            backPanel.topAnchor.constraint(equalTo: frontPanel.bottomAnchor),
            backPanel.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5),
            backPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButton(_:)))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        frontContent.delegate = self
        backContent.delegate = self
        
        if let card = card {
            frontContent.text = card.frontContent
            backContent.text = card.backContent
        }
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
            flashCardService.updateCard(card, frontContent: frontContent.text, backContent: backContent.text)
        }
        else {
            _ = flashCardService.newCard(in: contentPack, frontContent: frontContent.text, backContent: backContent.text, deck: nil)
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
    
    private var card: Card? = nil
    private var contentPack: ContentPack!
    
    private var frontContent: UITextView!
    private var backContent: UITextView!
    
    private var canSave: Bool {
        !frontContent.text.isEmpty
    }
}

