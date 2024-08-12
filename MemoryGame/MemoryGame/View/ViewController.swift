//
//  ViewController.swift
//  MemoryGame
//
//  Created by 8 on 9.08.24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var movesLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    let game = Game()
    var movesCounter = 0
    var timer: Timer?
    
    @IBAction func newGameTapped(_ sender: UIButton) {
        // MARK: перезапуск игры
        startGame()
    }
    
    var chosenCells: [Int] = [] {
        didSet {
            // MARK: здесь хранятся выбранные ячейки, и как только их становится 2 - происходит проверка пара ли они
            if chosenCells.count == 1 {
                let indexPath = IndexPath(item: chosenCells.last ?? 0, section: 0)
                collectionView.reloadItems(at: [indexPath])
            } else if chosenCells.count == 2 {
                let indexPath = IndexPath(item: chosenCells.last ?? 0, section: 0)
                collectionView.reloadItems(at: [indexPath])
                // MARK: таймер на секунду, чтобы юзер успел увидеть какое число скрывалось за второй ячейкой
                let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
                    self.checkCells()
                    self.movesCounter += 1
                    self.movesLabel.text = "Moves: \(self.movesCounter)"
                    self.collectionView.reloadData()
                }

            }
            checkGameOver()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startGame()
        self.collectionView.backgroundColor = .clear
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.contentInsetAdjustmentBehavior = .always
        let collectionNib = UINib(nibName: "CollectionViewCell", bundle: nil)
        self.collectionView.register(collectionNib, forCellWithReuseIdentifier: CollectionViewCell.identifier)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func startGame() {
        // MARK: обновление лейблов и таймера перед запуском новой игры и запуск
        timer?.invalidate()
        movesCounter = 0
        movesLabel.text = "Moves: \(movesCounter)"
        game.startNewGame()
        startTimer()
        collectionView.reloadData()
    }
    
    func checkCells() {
        // MARK: запуск проверки, можно добавить какую-нибудь анимацию на успех или неуспех
        if game.checkPair(chosenCells[0], chosenCells[1]) {
            print("Bingo!")
        } else {
            print("Nope.")
        }
        chosenCells.removeAll()
    }
    
    func setCell(index: Int) {
        // MARK: установка выбранной ячейки для проверки
        chosenCells.append(index)
        
    }
    
    func startTimer() {
        // MARK: таймер для обновления лейбла с временем раз в секунду
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.updateTimerLabel()
        }
    }
    
    func updateTimerLabel() {
        // MARK: обновление лейбла с временем
        if let gameTime = game.getGameTime() {
            timerLabel.text = String(format: "Time: %.0f", gameTime)
        }
    }
    
    func checkGameOver() {
        // MARK: проверка не угадал ли уже юзер все пары, и если угадал то алёрт и остановка игры
        if game.guessedPairs.count == game.pairs.count {
            timer?.invalidate()
            let alert = UIAlertController(title: "You Win!", message: "wow, that's impressive", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in
                alert.dismiss(animated: true)
            })
            present(alert, animated: true, completion: nil)
        }
        }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return game.pairs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
        // MARK: если ячейка не угадана - показывает "?"
        cell.label.text = " ? "
        if game.guessedPairs.contains(indexPath.row) {
            cell.label.text = " \(indexPath.row) : \(game.pairs[indexPath.row]!)"
        }
        // MARK: если ячейка нажата - отображается её индекс и индекс пары
        if chosenCells.contains(indexPath.row) {
            cell.label.text = " \(indexPath.row) : \(game.pairs[indexPath.row]!)"
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        setCell(index: indexPath.row)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 4
        // Match spacing below
        let spacing: CGFloat = 5
        let totalHorizontalSpacing = (columns - 1) * spacing

        let itemWidth = (collectionView.bounds.width - totalHorizontalSpacing) / columns
        let itemSize = CGSize(width: itemWidth, height: itemWidth * 1.2)

        return itemSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        // horizontal space between items
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // vertical space between lines
        return 5
    }
}

