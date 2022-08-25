//
//  UIViewController+Extensions.swift
//  DeckOfCards
//
//  Created by LanceMacBookPro on 8/24/22.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String?, message: String?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
