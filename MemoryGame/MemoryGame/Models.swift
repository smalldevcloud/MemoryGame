//
//  Models.swift
//  MemoryGame
//
//  Created by Alex Ch on 15.01.25.
//

import Foundation

class Card {
    let id: UUID
    let pairId: Int
    var isGuessed: Bool = false
    
    init(id: UUID, pairId: Int) {
        self.pairId = pairId
        self.id = id
    }
}

struct Pair {
    let id: Int
    let firstItem: Card
    let secondItem: Card
    
    func isPair(for pair: Pair) -> Bool {
        return false
    }
}

struct GameModel {
    private var pairs: [Pair] = []
    var cards: [Card] = []
    mutating func generateNewGame() {
        self.pairs = []
        self.cards = []
        var counter = 1
        for _ in 0...7 {
            let newPair = Pair(
                id: counter,
                firstItem: Card(id: UUID(), pairId: counter),
                secondItem: Card(id: UUID(), pairId: counter))
            pairs.append(newPair)
            counter += 1
        }
        for pair in pairs {
            cards.append(pair.firstItem)
            cards.append(pair.secondItem)
        }
        cards.shuffle()
    }
    
    func checkPair(cardPairId: Int) {
        
    }
}
