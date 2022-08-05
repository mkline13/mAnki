//
//  DeckEditorViewController.swift
//  FlashCards
//
//  Created by Work on 8/5/22.
//

import UIKit

class DeckEditorViewController: UIViewController {
    // MARK: View
    override func viewDidLoad() {
        if let deck = deck {
            
        }
        else {
            
        }
    }
    
    override func loadView() {
        view = UIView(frame: .zero)
        view.backgroundColor = UIColor.systemBackground
    }
    
    // MARK: Properties
    private var table: UITableView!
    var deck: Deck?
}
