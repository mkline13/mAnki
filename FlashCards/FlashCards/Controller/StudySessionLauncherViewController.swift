//
//  StudySessionSetupViewController.swift
//  FlashCards
//
//  Created by Work on 8/7/22.
//

import UIKit


class StudySessionLauncherViewController: UIViewController {
    init (for deck: Deck, flashCardService: FlashCardService) {
        super.init(nibName: nil, bundle: nil)
        self.deck = deck
        self.flashCardService = flashCardService
        
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        title = "Study"
        
        view = UIView(frame: .zero)
        view.backgroundColor = UIColor.systemBackground
        
        tableView = UITableView.init(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        let buttonPanel = UIView()
        buttonPanel.translatesAutoresizingMaskIntoConstraints = false
        buttonPanel.backgroundColor = UIColor.secondarySystemBackground

        let goButtonAction = UIAction(handler: { _ in self.beginStudy(with: self.deck)})
        goButtonAction.title = "Begin"

        goButton = UIButton.init(type: .custom, primaryAction: goButtonAction)
        goButton.translatesAutoresizingMaskIntoConstraints = false
        goButton.backgroundColor = UIColor.systemBlue
        goButton.layer.cornerRadius = 8
        goButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        goButton.setTitle("Begin", for: .normal)
        goButton.setTitle("No Cards", for: .disabled)

        buttonPanel.addSubview(goButton)
        buttonPanel.addConstraints([
            goButton.centerXAnchor.constraint(equalTo: buttonPanel.centerXAnchor),
            goButton.centerYAnchor.constraint(equalTo: buttonPanel.centerYAnchor),
            goButton.widthAnchor.constraint(equalTo: buttonPanel.widthAnchor, multiplier: 2.0/3.0)
        ])

        view.addSubview(tableView)
        view.addSubview(buttonPanel)
        view.addConstraints([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            buttonPanel.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 1.0/5.0),
            buttonPanel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            buttonPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(editButton(_:)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.deck.cards.count > 0 {
            goButton.isEnabled = true
            goButton.tintColor = nil
        }
        else {
            goButton.isEnabled = false
            goButton.backgroundColor = UIColor.systemGray
        }
    }
    
    // MARK: Table
    enum Row: CaseIterable {
        case titleLabel
        case descriptionLabel
        case newCardsRemaining
        case reviewCardsRemaining
    }
    
    // MARK: Actions
    @objc private func editButton(_ sender: UIBarButtonItem) {
        let vc = DeckSettingsViewController(for: deck, flashCardService: flashCardService)
        show(vc, sender: self)
    }
    
    private func beginStudy(with deck: Deck) {
        guard let vc = try? StudySessionViewController(for: deck, flashCardService: flashCardService) else {
            fatalError("Cannot study: deck is empty")
        }
        
        show(vc, sender: self)
    }
    
    // MARK: Properties
    private var tableView: UITableView!
    private var goButton: UIButton!
    
    private var deck: Deck!
    private var flashCardService: FlashCardService!
}
