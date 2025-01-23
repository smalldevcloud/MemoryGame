//
//  GameViewModel.swift
//  MemoryGame
//
//  Created by Alex Ch on 18.01.25.
//

import Foundation

extension GameViewModel {
    enum MainState {
        case firstLaunch
        case newGameStarted([Card])
        case openCard(Int)
        case updateCollection
        case gameOver
    }
    
    enum StepsState {
        case zeroState
        case newValue(Int)
    }
    
    enum TimerState {
        case zeroState
        case newValue(String)
    }
}

class GameViewModel {
    var mainState = Dynamic<MainState>(.firstLaunch)
    var stepsState = Dynamic<StepsState>(.zeroState)
    var timerState = Dynamic<TimerState>(.zeroState)
    var timer: Timer?
    var game = Game()
    var movesCounter = 0 {
        didSet {
            stepsState.value = .newValue(movesCounter)
        }
    }

    var stepsController = StepsController()
    
    func start() {
        mainState.value = .firstLaunch
        stepsState.value = .zeroState
    }
    
    func startNewGame() {
        timer?.invalidate()
        
        game.generateNewGame()
        mainState.value = .newGameStarted(game.cards)
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            guard let gameTime = self.game.startTime else { return }
            let interval = Date().timeIntervalSince(gameTime)

            self.timerState.value = .newValue(interval.stringFromTimeInterval())
        }
    }
    
    func cardTapped(at cardNumber: Int) {
        let tappedCard = game.cards[cardNumber]
        guard !game.isBlocked else {
            print("is blocked, bitch!")
            return
        }
        guard !tappedCard.isGuessed else {
            print("is guessed, bitch!")
            return
        }
        guard !tappedCard.isOpen else {
            print("is already open, bitch!")
            return
        }
        
        tappedCard.isOpen = true
        mainState.value = .openCard(cardNumber)
        if game.isMatch(cardIndex: cardNumber) {
            print("game.isMatch")
            mainState.value = .updateCollection
            if game.checkGameOver() {
                mainState.value = .gameOver
            }
        } else {
            
            DispatchQueue.main.async {
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
                    tappedCard.isOpen = false
                    self.mainState.value = .updateCollection
                    self.game.isBlocked = false
                    print("!game.isMatch")
                }
            }
        }

        
    }
    
    func checkIsPair(cardOne: Card, cardTwo: Card) -> Bool {
        return cardOne.pairId == cardTwo.pairId ? true : false
    }
    
    func checkGameOver() {
        var counter = 0
        for card in game.cards {
            if card.isGuessed == true {
                counter += 1
            }
        }
        if counter == game.cards.count {
            mainState.value = .gameOver
        }
    }
}
