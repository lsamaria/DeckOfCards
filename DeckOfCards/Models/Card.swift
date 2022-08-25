//
//  Cards.swift
//  DeckOfCards
//
//  Created by LanceMacBookPro on 8/25/22.
//

import Foundation

struct Card: Decodable {
    
    var code: String?
    var image: String?
    var images: CardImages?
    var value: String?
    var suit: String?
}
