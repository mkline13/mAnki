//
//  DeckListViewController.swift
//  FlashCards
//
//  Created by Work on 8/5/22.
//

import UIKit


class ContentPackListViewController: UIViewController {
    convenience init(flashCardService fcs: FlashCardService) {
        self.init(nibName: nil, bundle: nil)
        flashCardService = fcs
    }
    
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        title = "Content Packs"
        
        // Set views
        view = UIView(frame: .zero)
        view.backgroundColor = UIColor.systemBackground
        
        // Tab bar
        tabBarItem.image = UIImage(systemName: "books.vertical")
        tabBarItem.selectedImage = tabBarItem.image
        
        // Nav bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addContentPack(_:)))
    }
    
    // MARK: Actions
    @objc private func addContentPack(_ sender: UIBarButtonItem) {
        print("ADD CONTENT PACK")
    }
    
    // MARK: Properties
    private var flashCardService: FlashCardService!
}
