//
//  DataViewer.swift
//  FlashCards
//
//  Created by Work on 8/13/22.
//

import UIKit


class DataLabel: UILabel {
    init (dataProvider dp: DataProvider?) {
        dataProvider = dp
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // DATALABEL
    func update() {
        guard let dataProvider = dataProvider else {
            return
        }
        
        self.text = dataProvider()
    }
    
    let dataProvider: DataProvider?
    typealias DataProvider = () -> String
}
