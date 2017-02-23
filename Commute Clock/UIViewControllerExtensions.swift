//
//  UIViewControllerExtensions.swift
//  Commute Clock
//
//  Created by Alec Rodgers on 2/9/17.
//  Copyright © 2017 Alec Rodgers. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func displayAlert(title: String, message: String, buttonText: String) {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: buttonText, style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}
