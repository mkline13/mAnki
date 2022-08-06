//
//  IncDecCell.swift
//  FlashCards
//
//  Created by Work on 8/5/22.
//

import UIKit


class IncDecCell: UITableViewCell, FormField {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Make cell unselectable
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: FormField
    func configure(label: String?, key: Int, value: Any, delegate: FormFieldDelegate) {
        self.key = key
        self.delegate = delegate
    }
    
    // MARK: Properties
    static let reuseIdentifier: String = "IncDecCell"
    private var key: Int!
    private var delegate: FormFieldDelegate!
}
