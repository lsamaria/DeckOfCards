//
//  UILabel+Extensions.swift
//  DeckOfCards
//
//  Created by LanceMacBookPro on 8/24/22.
//

import UIKit

extension UILabel {
    
    static func createUILabel(textAlignment: NSTextAlignment, numOfLines: Int = 1, font: UIFont) -> UILabel {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = textAlignment
        label.numberOfLines = numOfLines
        label.font = font
        
        if numOfLines == 1 {
            label.lineBreakMode = .byTruncatingTail
        }
        
        return label
    }
}
