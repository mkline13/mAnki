//
//  ViewController.swift
//  FlashCards
//
//  Created by Work on 8/1/22.
//

import UIKit

class RootViewController: UIViewController {
    // MARK: Dependencies
    private let flashCardService: FlashCardService
    
    // MARK: IBSegueActions
    @IBSegueAction func createStudyDeckListViewController (coder: NSCoder) -> StudyDeckListViewController? {
        return StudyDeckListViewController(coder: coder, flashCardService: self.flashCardService)
    }
    
    @IBSegueAction func createContentPackListViewController (coder: NSCoder) -> ContentPackListViewController? {
        ContentPackListViewController(coder: coder, flashCardService: self.flashCardService)
    }
    
    // MARK: Initializers
    required init? (coder: NSCoder) {
        // Inject Dependencies
        flashCardService = DependencyContainer.shared.flashCardService
        super.init(coder: coder)
    }
}
