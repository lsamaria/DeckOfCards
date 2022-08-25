//
//  UIActivityIndicatorView+Extensions.swift
//  DeckOfCards
//
//  Created by LanceMacBookPro on 8/24/22.
//

import UIKit

extension UIActivityIndicatorView {
    
    static func createActivityIndicatorView(color: UIColor = .gray) -> UIActivityIndicatorView {
        
        let activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.color = color
        return activityIndicatorView
    }
}
