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
        case updateCollection(MoveAction)
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

    func start() {
        game.generateNewGame()
        mainState.value = .firstLaunch
        stepsState.value = .zeroState
    }
    
    func startNewGame() {
        game.startGame()
        mainState.value = .newGameStarted(game.cards)
        stepsState.value = .newValue(game.steps)
        timer?.invalidate()
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                guard let gameTime = self.game.startTime else {
                    return }
                let interval = Date().timeIntervalSince(gameTime)
                
                self.timerState.value = .newValue(interval.stringFromTimeInterval())
            }
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
        
        switch game.isMatch(cardIndex: cardNumber) {
            
        case .gussed:
            DispatchQueue.main.async {
                self.mainState.value = .updateCollection(.gussed)
                if self.game.checkGameOver() {
                    self.stopGame()
                }
            }
        case .notGuessed:
            //тут нажатая карта снова станет закрытой по интервалу в 1с
            DispatchQueue.main.async {
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
                    tappedCard.isOpen = false
                    self.mainState.value = .updateCollection(.notGuessed)
                    self.game.isBlocked = false
                }
            }
        case .firstTap:
            self.mainState.value = .updateCollection(.firstTap)
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

}
