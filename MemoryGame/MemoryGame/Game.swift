//
//  Game.swift
//  MemoryGame
//
//  Created by 8 on 9.08.24.
//

import Foundation

class Gameffff {
    var pairs: [Int: Int] = [:]
    var guessedPairs: [Int] = []
    var startTime: Date?
    
    func startNewGame() {
        // MARK: запуск новой игры
        guessedPairs.removeAll()
        pairs.removeAll()
        
        startTime = Date()
        pairs = generateRandomPairs()
    }
    
    func generateRandomPairs() -> [Int: Int] {
        // MARK: создаёт 16 значений ключ:пара указывающие друг на друга и случайно их перемешивает, чтобы в новй игре был другой порядок
        var arr: [Int: Int] = [:]
        var indices = Array(0...15)
        indices.shuffle()
        
        for i in stride(from: 0, to: indices.count, by: 2) {
            let firstIndex = indices[i]
            let secondIndex = indices[i + 1]
            arr[firstIndex] = secondIndex
            arr[secondIndex] = firstIndex
        }
        
        return arr
    }
    
    func checkPair(_ indexA: Int, _ indexB: Int) -> Bool {
        // MARK: проверка выбранной пары
        if !guessedPairs.contains(indexA) {
            if pairs[indexA] == indexB {
                // MARK: если угадано - обновляется массив с угаданными
                guessedPairs.append(indexA)
                guessedPairs.append(indexB)
                return true
            } else {
                // MARK: если не угадано, ничего не происходит
                return false
            }
        } else {
            // MARK: если уже добавлено в массив угаданных, тоже ничего
            return false
        }
    }
    
    func getGameTime() -> TimeInterval? {
        // MARK: запись времени начала игры 
        guard let startTime = startTime else { return nil }
        return Date().timeIntervalSince(startTime)
    }
}

