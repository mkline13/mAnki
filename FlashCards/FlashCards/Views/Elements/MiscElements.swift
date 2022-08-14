//
//  MiscElements.swift
//  FlashCards
//
//  Created by Work on 8/10/22.
//

import UIKit


class Spacer: UIView {
    init () {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class Separator: UIView {
    init () {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundColor = .separator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 0.5)
    }
}
