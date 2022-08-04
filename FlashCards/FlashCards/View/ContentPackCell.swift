//
//  ContentPackCell.swift
//  FlashCards
//
//  Created by Work on 8/4/22.
//

import UIKit


class ContentPackCell: UITableViewCell {
    // MARK: IB
    @IBOutlet private weak var label: UILabel!
    
    func configure(for contentPack: ContentPack) {
        label.text = contentPack.title
    }
}
