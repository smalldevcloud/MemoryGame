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
        case settings
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

    func start() {
        game.generateNewGame()
        mainState.value = .firstLaunch
        stepsState.value = .zeroState
    }
    
    func startNewGame() {

        
        mainState.value = .newGameStarted(game.cards)
        stepsState.value = .newValue(game.steps)
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
            print("is blocked")
            return
        }
        guard !tappedCard.isGuessed else {
            print("is guessed")
            return
        }
        guard !tappedCard.isOpen else {
            print("is already open")
            return
        }
        
        tappedCard.isOpen = true
        mainState.value = .openCard(cardNumber)
        if game.isMatch(cardIndex: cardNumber) {
            DispatchQueue.main.async {
                self.mainState.value = .updateCollection
                if self.game.checkGameOver() {
                    self.stopGame()
                }
            }
        } else {
            DispatchQueue.main.async {
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
                    tappedCard.isOpen = false
                    self.mainState.value = .updateCollection
                    self.game.isBlocked = false
                }
            }
        }
        
        DispatchQueue.main.async {
            self.stepsState.value = .newValue(self.game.steps)
        }
    }

    func stopGame() {
        DispatchQueue.main.async {
            self.mainState.value = .gameOver
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    func switchToSettings() {
        DispatchQueue.main.async {
            self.mainState.value = .settings
        }
    }
}
