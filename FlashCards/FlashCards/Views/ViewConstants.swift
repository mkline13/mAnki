//
//  ViewConstants.swift
//  FlashCards
//
//  Created by Work on 8/13/22.
//

import UIKit


let ViewConstants = ViewConstantsContainer()


struct ViewConstantsContainer {
    fileprivate init() {
        titleFont = .systemFont(ofSize: 22, weight: .bold)
        smallTitleFont = .systemFont(ofSize: 17, weight: .medium)
        regularFont = .systemFont(ofSize: 14)
        smallFont = .systemFont(ofSize: 12)
        
        labelColor = .systemGray2
    }
    
    let titleFont: UIFont
    let smallTitleFont: UIFont
    let regularFont: UIFont
    let smallFont: UIFont
    
    let labelColor: UIColor
}
