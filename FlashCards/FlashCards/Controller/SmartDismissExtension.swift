//
//  SmartDismissExtension.swift
//  FlashCards
//
//  Created by Work on 8/10/22.
//

import UIKit


extension UIViewController {
    func smartDismiss (animated: Bool) {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: animated)
        }
        else {
            dismiss(animated: animated)
        }
    }
}
