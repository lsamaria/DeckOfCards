//
//  Deck.swift
//  DeckOfCards
//
//  Created by LanceMacBookPro on 8/25/22.
//

import Foundation

struct Deck: Decodable {
    
    var success: Bool?
    var deck_id: String?
    var cards = [Card]()
    var remaining: Int?
}
