//
//  View+addSubviewAndFit.swift
//  FlashCards
//
//  Created by Work on 8/13/22.
//

import UIKit


extension UIView {
    func addSubviewAndFit(_ view: UIView) {
        self.addSubview(view)
        
        self.addConstraints([
            view.topAnchor.constraint(equalTo: self.topAnchor),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
    func addSubviewAndFitSafeTop(_ view: UIView) {
        self.addSubview(view)
        
        self.addConstraints([
            view.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
}
