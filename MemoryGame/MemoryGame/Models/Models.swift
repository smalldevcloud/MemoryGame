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
    var isOpen: Bool = false
    init(id: UUID, pairId: Int) {
        self.pairId = pairId
        self.id = id
    }
}

struct Pair {
    let id: Int
    let firstItem: Card
    let secondItem: Card
}

struct Game {
    private var pairs: [Pair] = []
    private var guessedPairs: [Pair] = []
    var cards: [Card] = []
    var chosenCard: Card?
    var isBlocked = false
    var startTime: Date?
    var steps: Int = 0
    
    mutating func generateNewGame() {
        self.pairs = []
        self.guessedPairs = []
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
    
    mutating func startGame() {
        startTime = Date()
        steps = 0
    }
    
    mutating func isMatch(cardIndex: Int) -> MoveAction {
        isBlocked = true
        guard cards[cardIndex].id != chosenCard?.id else {
            print("is already open!")
            return .notGuessed
        }
        
        if let currCard = chosenCard {
            steps += 1
            if cards[cardIndex].pairId == currCard.pairId {
                currCard.isGuessed = true
                cards[cardIndex].isGuessed = true
                chosenCard = nil
                isBlocked = false
                setGuessedPair(pairId: currCard.pairId)
                return .gussed
            } else {
                isBlocked = false
                chosenCard?.isOpen = false
                chosenCard = nil
                return .notGuessed
            }
            
        } else {
            chosenCard = cards[cardIndex]
            isBlocked = false
            return .firstTap
        }
        
    }
    mutating func setGuessedPair(pairId: Int) {
        for pair in pairs {
            if pair.id == pairId {
                guessedPairs.append(pair)
            }
        }
    }
    
    mutating func checkGameOver() -> Bool {
        if guessedPairs.count == pairs.count {
            return true
        } else {
            return false
        }
    }
}

enum MoveAction {
    case gussed
    case notGuessed
    case firstTap
}



extension TimeInterval{

        func stringFromTimeInterval() -> String {

            let time = NSInteger(self)

//            let ms = Int((self.truncatingRemainder(dividingBy: 1)) * 1000)
            let seconds = time % 60
            let minutes = (time / 60) % 60
//            let hours = (time / 3600)

            return String(format: "%0.2d:%0.2d",minutes,seconds)

        }
    }
